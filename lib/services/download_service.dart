import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import '../core/helpers/media_url_helper.dart';
import '../core/helpers/prefs_helper.dart';
import 'api_constants.dart';

// Class to represent downloaded content with metadata
class DownloadedContent {
  final String filePath;
  final String title;
  final String subtitle;
  final String meta;
  final String hashtags;
  final String originalMediaUrl;
  final DateTime downloadDate;

  DownloadedContent({
    required this.filePath,
    required this.title,
    required this.subtitle,
    required this.meta,
    required this.hashtags,
    required this.originalMediaUrl,
    required this.downloadDate,
  });

  Map<String, dynamic> toJson() => {
        'filePath': filePath,
        'title': title,
        'subtitle': subtitle,
        'meta': meta,
        'hashtags': hashtags,
        'originalMediaUrl': originalMediaUrl,
        'downloadDate': downloadDate.toIso8601String(),
      };

  static DownloadedContent fromJson(Map<String, dynamic> json) => DownloadedContent(
        filePath: json['filePath'] as String,
        title: json['title'] as String,
        subtitle: json['subtitle'] as String,
        meta: json['meta'] as String,
        hashtags: json['hashtags'] as String,
        originalMediaUrl: json['originalMediaUrl'] as String,
        downloadDate: json['downloadDate'] != null
          ? DateTime.parse(json['downloadDate'] as String)
          : DateTime.now(),
      );
}

class DownloadService {
  static final DownloadService _instance = DownloadService._internal();
  factory DownloadService() => _instance;
  DownloadService._internal();

  /// Why the last [downloadMedia] call failed, so the UI can say something
  /// more useful than "Could not save video to device".
  String lastError = '';

  /// True when the last successful download also landed in the system
  /// gallery / Photos app (as opposed to only the in-app Downloads folder).
  bool lastSavedToGallery = false;

  /// The value the API expects in the `Authorization` header.
  ///
  /// The backend rejects a "Bearer " prefix — `ApiClient` sends the raw token
  /// and this service used to send `Bearer <token>`, which came back as
  /// 500 "invalid token", so every authenticated download failed.
  Future<String> _getAuthToken() async {
    try {
      return await PrefsHelper.getString('bearerToken');
    } catch (e) {
      print('Error getting auth token: $e');
      return ''; // Return empty string if no token available
    }
  }

  /// Only our own API gets the session token. Third-party hosts (S3 presigned
  /// links, image CDNs) must never receive it.
  bool _isOwnApi(String url) {
    final host = Uri.tryParse(url)?.host ?? '';
    return host.isNotEmpty && ApiConstants.imageBaseUrl.contains(host);
  }

  // Helper method to check if URL is an S3 URL
  bool _isS3Url(String url) {
    return url.contains('.s3.') ||
           url.contains('s3.amazonaws.com') ||
           url.contains('s3-') ||
           url.contains('story-telling-bucket-s3');
  }

  // Directory for downloaded images
  Future<Directory> _getDownloadDirectory() async {
    Directory? directory;

    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
      directory ??= await getApplicationDocumentsDirectory();
      directory = Directory('${directory.path}/KlokkinApp/Downloads');
    } else {
      // iOS / iPadOS: the app's own Documents folder needs no permission and
      // is exposed to the Files app (UIFileSharingEnabled in Info.plist).
      final docs = await getApplicationDocumentsDirectory();
      directory = Directory('${docs.path}/Downloads');
    }

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    return directory;
  }

  /// Asks for the *add-only* photo permission (iOS) / media permission
  /// (Android) used to copy a finished download into the system gallery.
  ///
  /// Guideline 2.1(a): the reviewer hit "Download Failed" on iPad. The old
  /// code requested full `Permission.photos` (read + write) *before*
  /// downloading anything and treated everything other than `granted` —
  /// iOS 14+ "Limited Access" included — as a hard failure, so the download
  /// was aborted before a single byte was fetched. Copying into the gallery is
  /// now best-effort only; the file always lands in the app's own Downloads
  /// folder, which requires no permission at all.
  Future<bool> _canSaveToGallery() async {
    try {
      if (Platform.isIOS) {
        // Add-only is the least privilege iOS needs to write into the photo
        // library, and is backed by NSPhotoLibraryAddUsageDescription.
        var status = await Permission.photosAddOnly.status;
        if (status.isGranted || status.isLimited) return true;
        if (status.isPermanentlyDenied || status.isRestricted) return false;
        status = await Permission.photosAddOnly.request();
        return status.isGranted || status.isLimited;
      }

      // Android 13+ (API 33+) uses the media permissions, older versions the
      // legacy storage permission.
      if (await Permission.photos.isGranted) return true;
      final photosStatus = await Permission.photos.request();
      if (photosStatus.isGranted || photosStatus.isLimited) return true;

      if (await Permission.storage.isGranted) return true;
      final storageStatus = await Permission.storage.request();
      return storageStatus.isGranted;
    } catch (e) {
      // A permission-plugin failure must never kill the download itself.
      print('Gallery permission check failed: $e');
      return false;
    }
  }

  /// Kept so older call sites keep compiling. Downloads no longer depend on
  /// this returning true.
  Future<bool> requestStoragePermission() => _canSaveToGallery();

  Future<http.Response> _fetch(String url) async {
    final token = await _getAuthToken();
    final authHeader = <String, String>{
      if (token.isNotEmpty && _isOwnApi(url) && !_isS3Url(url))
        'Authorization': token,
    };

    // Try the most likely header set first, then the other one: presigned S3
    // links break *with* a header, our own API breaks *without* one.
    final attempts = authHeader.isEmpty
        ? [<String, String>{}]
        : [authHeader, <String, String>{}];

    http.Response? last;
    for (final headers in attempts) {
      last = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 60));
      if (last.statusCode == 200) return last;
    }
    return last!;
  }

  // Download media from URL and save to device with metadata
  Future<bool> downloadMedia(
    String mediaUrl, {
    String? fileName,
    String title = 'Downloaded Media',
    String subtitle = 'Saved locally on your device',
    String meta = 'Media',
    String hashtags = 'Media',
  }) async {
    lastError = '';
    lastSavedToGallery = false;

    if (MediaUrlHelper.isYoutubeLink(mediaUrl)) {
      lastError = 'This story streams from YouTube and cannot be downloaded.';
      return false;
    }

    final url = MediaUrlHelper.normalize(mediaUrl);
    if (url == null) {
      lastError = 'This story has no downloadable file.';
      return false;
    }

    String? mediaPath;
    try {
      final response = await _fetch(url);

      if (response.statusCode != 200) {
        print('Failed to download media: ${response.statusCode}');
        lastError = response.statusCode == 401 || response.statusCode == 403
            ? 'You are not allowed to download this file. Please sign in again.'
            : 'The server could not deliver this file (${response.statusCode}).';
        return false;
      }

      if (response.bodyBytes.isEmpty) {
        lastError = 'The downloaded file was empty.';
        return false;
      }

      // A web page instead of a media file means the link is not a real asset;
      // saving it would produce an unplayable file in the Downloads list.
      final contentType =
          (response.headers['content-type'] ?? '').toLowerCase();
      if (contentType.contains('text/html')) {
        lastError = 'This story links to a web page, not a downloadable file.';
        return false;
      }

      // Get download directory
      final downloadDir = await _getDownloadDirectory();

      // Work out the real file type. Some media URLs carry no extension at
      // all (image CDNs, presigned links), and guessing ".mp4" for a JPEG
      // produced a file the Photos app refused to import.
      final isImage = _isImageResponse(contentType, url);
      final extension = _extensionFor(contentType, url, isImage: isImage);
      if (fileName == null || fileName.isEmpty) {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        fileName = 'klokkin_media_$timestamp$extension';
      } else if (path.extension(fileName).isEmpty) {
        fileName = '$fileName$extension';
      }

      // Create file path for the media
      mediaPath = '${downloadDir.path}/$fileName';
      final mediaFile = File(mediaPath);

      // Write media data to file
      await mediaFile.writeAsBytes(response.bodyBytes);

      // Create content object with metadata
      final content = DownloadedContent(
        filePath: mediaPath,
        title: title,
        subtitle: subtitle,
        meta: meta,
        hashtags: hashtags,
        originalMediaUrl: url,
        downloadDate: DateTime.now(),
      );

      // Create metadata file with the same name but .json extension
      final metadataFileName = fileName.replaceAll(path.extension(fileName), '.json');
      final metadataPath = '${downloadDir.path}/$metadataFileName';
      await File(metadataPath).writeAsString(jsonEncode(content.toJson()));

      // Best-effort copy into the system gallery. A refusal here (permission
      // denied, unsupported container, simulator quirks) must not turn a
      // perfectly good download into a user-facing failure.
      await _saveToGalleryQuietly(
        mediaPath: mediaPath,
        fileName: fileName,
        bytes: response.bodyBytes,
        isImage: isImage,
      );

      return true;
    } catch (e) {
      print('Error downloading media: $e');
      lastError = e is SocketException
          ? 'No internet connection. Please try again.'
          : 'Download failed. Please try again.';

      // Clean up any partial download so the Downloads list stays clean.
      try {
        if (mediaPath != null) {
          final partial = File(mediaPath);
          if (await partial.exists()) await partial.delete();
        }
        if (fileName != null) {
          final downloadDir = await _getDownloadDirectory();
          final metadataFileName =
              fileName.replaceAll(path.extension(fileName), '.json');
          final metadataFile = File('${downloadDir.path}/$metadataFileName');
          if (await metadataFile.exists()) await metadataFile.delete();
        }
      } catch (cleanupError) {
        print('Error during cleanup: $cleanupError');
      }
      return false;
    }
  }

  /// Content type wins over the URL: the URL may carry no extension at all.
  bool _isImageResponse(String contentType, String url) {
    if (contentType.startsWith('image/')) return true;
    if (contentType.startsWith('video/') || contentType.startsWith('audio/')) {
      return false;
    }
    return MediaUrlHelper.isImageUrl(url);
  }

  String _extensionFor(String contentType, String url, {required bool isImage}) {
    const byMime = {
      'image/jpeg': '.jpg',
      'image/jpg': '.jpg',
      'image/png': '.png',
      'image/gif': '.gif',
      'image/webp': '.webp',
      'image/heic': '.heic',
      'video/mp4': '.mp4',
      'video/quicktime': '.mov',
      'video/webm': '.webm',
      'audio/mpeg': '.mp3',
      'audio/mp4': '.m4a',
      'audio/aac': '.aac',
      'audio/wav': '.wav',
    };
    final mime = contentType.split(';').first.trim();
    final fromMime = byMime[mime];
    if (fromMime != null) return fromMime;
    return MediaUrlHelper.extensionOf(url, fallback: isImage ? '.jpg' : '.mp4');
  }

  Future<void> _saveToGalleryQuietly({
    required String mediaPath,
    required String fileName,
    required List<int> bytes,
    required bool isImage,
  }) async {
    try {
      if (!await _canSaveToGallery()) return;

      // The plugin can block forever instead of returning or throwing when
      // the photo-library authorisation is in an odd state — observed on an
      // iPad simulator, where the call never came back. Without this timeout
      // the download button would spin indefinitely, which is precisely the
      // hang App Review flags under 2.1(a).
      final Future<dynamic> saving = Future<dynamic>.value(isImage
          ? ImageGallerySaverPlus.saveImage(
              Uint8List.fromList(bytes),
              name: path.basenameWithoutExtension(fileName),
              quality: 100,
            )
          : ImageGallerySaverPlus.saveFile(
              mediaPath,
              name: path.basenameWithoutExtension(fileName),
            ));
      final result = await saving.timeout(const Duration(seconds: 20));

      lastSavedToGallery = (result is Map && result['isSuccess'] == true);
    } catch (galleryError) {
      print('Gallery save failed (download still succeeded): $galleryError');
      lastSavedToGallery = false;
    }
  }

  // Get list of downloaded content with metadata
  Future<List<DownloadedContent>> getDownloadedContent() async {
    try {
      final downloadDir = await _getDownloadDirectory();
      if (!await downloadDir.exists()) {
        return [];
      }

      final contents = <DownloadedContent>[];

      // Get all JSON metadata files
      await for (FileSystemEntity entity in downloadDir.list()) {
        if (entity is File && path.extension(entity.path).toLowerCase() == '.json') {
          try {
            final jsonString = await entity.readAsString();
            final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
            final content = DownloadedContent.fromJson(jsonMap);

            // Check if the associated image file still exists
            final imageFile = File(content.filePath);
            if (await imageFile.exists()) {
              contents.add(content);
            } else {
              // Clean up orphaned metadata files
              await entity.delete();
            }
          } catch (e) {
            print('Error parsing metadata file: $e');
          }
        }
      }

      // Sort by download date (newest first)
      contents.sort((a, b) => b.downloadDate.compareTo(a.downloadDate));

      return contents;
    } catch (e) {
      print('Error getting downloaded content: $e');
      return [];
    }
  }

  // Delete a downloaded content (both image and metadata)
  Future<bool> deleteDownloadedContent(String filePath) async {
    try {
      // Delete the image file
      final imageFile = File(filePath);
      if (await imageFile.exists()) {
        await imageFile.delete();
      }

      // Find and delete the associated metadata file
      final downloadDir = await _getDownloadDirectory();
      final fileName = path.basename(filePath);
      final metadataFileName = fileName.replaceAll(path.extension(fileName), '.json');
      final metadataPath = '${downloadDir.path}/$metadataFileName';
      final metadataFile = File(metadataPath);

      if (await metadataFile.exists()) {
        await metadataFile.delete();
      }

      return true;
    } catch (e) {
      print('Error deleting downloaded content: $e');
      return false;
    }
  }

  // Delete a downloaded content by DownloadedContent object
  Future<bool> deleteDownloadedContentByObject(DownloadedContent content) async {
    return await deleteDownloadedContent(content.filePath);
  }

  // Get file info
  Future<Map<String, dynamic>> getFileInfo(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return {};
      }

      final stat = await file.stat();
      final name = path.basename(filePath);
      final size = stat.size;
      final modified = stat.modified;

      return {
        'name': name,
        'size': size,
        'modified': modified,
        'path': filePath,
      };
    } catch (e) {
      print('Error getting file info: $e');
      return {};
    }
  }

  // Backward compatibility method - deprecated
  @Deprecated('Use downloadMedia instead')
  Future<bool> downloadImage(
    String imageUrl, {
    String? fileName,
    String title = 'Downloaded Image',
    String subtitle = 'Saved locally on your device',
    String meta = 'Image',
    String hashtags = 'Image',
  }) async {
    return await downloadMedia(
      imageUrl,
      fileName: fileName,
      title: title,
      subtitle: subtitle,
      meta: meta,
      hashtags: hashtags,
    );
  }
}
