import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

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

  // Directory for downloaded images
  Future<Directory> _getDownloadDirectory() async {
    Directory? directory;
    
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
      if (directory != null) {
        directory = Directory('${directory.path}/KlokkinApp/Downloads');
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
      }
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
      directory = Directory('${directory.path}/Downloads');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
    }
    
    return directory!;
  }

  // Request storage permission
  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      // For Android 13+ (API 33+), use media permissions
      if (await Permission.photos.isGranted) return true;
      var photosStatus = await Permission.photos.request();
      if (photosStatus.isGranted) return true;

      // For older Android versions or if photos permission fails, try storage
      if (await Permission.storage.isGranted) return true;
      var storageStatus = await Permission.storage.request();
      return storageStatus.isGranted;
    } else if (Platform.isIOS) {
      if (await Permission.photos.isGranted) return true;
      var status = await Permission.photos.request();
      return status.isGranted;
    }
    return true; // iOS doesn't require explicit storage permission
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
    try {
      // Request storage permission if needed
      bool hasPermission = await requestStoragePermission();
      if (!hasPermission) {
        throw Exception('Storage permission not granted');
      }

      // Create HTTP client and download media
      final response = await http.get(Uri.parse(mediaUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to download media: ${response.statusCode}');
      }

      // Get download directory
      final downloadDir = await _getDownloadDirectory();
      
      // Generate filename if not provided
      if (fileName == null || fileName.isEmpty) {
        final urlPath = Uri.parse(mediaUrl).path;
        final originalFileName = path.basename(urlPath);
        final extension = path.extension(originalFileName);
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        fileName = 'klokkin_media_$timestamp$extension';
      }

      // Create file path for the media
      final mediaPath = '${downloadDir.path}/$fileName';
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
        originalMediaUrl: mediaUrl,
        downloadDate: DateTime.now(),
      );
      
      // Create metadata file with the same name but .json extension
      final metadataFileName = fileName.replaceAll(path.extension(fileName), '.json');
      final metadataPath = '${downloadDir.path}/$metadataFileName';
      final metadataFile = File(metadataPath);
      
      // Write metadata to JSON file
      await metadataFile.writeAsString(jsonEncode(content.toJson()));

      // Also save to gallery for easier access (this might fail on some devices)
      // ImageGallerySaverPlus supports both images and videos
      bool galleryResult = true;
      try {
        // For images
        if (fileName.toLowerCase().endsWith('.jpg') || 
            fileName.toLowerCase().endsWith('.jpeg') || 
            fileName.toLowerCase().endsWith('.png') || 
            fileName.toLowerCase().endsWith('.gif') ||
            fileName.toLowerCase().endsWith('.webp')) {
          final result = await ImageGallerySaverPlus.saveImage(
            Uint8List.fromList(response.bodyBytes),
            name: fileName,
            quality: 100,
          );
          galleryResult = result['isSuccess'] ?? false;
        } else {
          // For videos and other files
          final result = await ImageGallerySaverPlus.saveFile(
            mediaPath,
            name: fileName,
          );
          galleryResult = result['isSuccess'] ?? false;
        }
      } catch (galleryError) {
        print('Gallery save failed: $galleryError');
        // Don't fail the entire download if gallery save fails
        galleryResult = true;
      }

      // Return true if the file was saved successfully (gallery save is optional)
      return true;
    } catch (e) {
      print('Error downloading media: $e');
      // Clean up any partial downloads
      try {
        final downloadDir = await _getDownloadDirectory();
        final metadataFileName = fileName?.replaceAll(path.extension(fileName!), '.json') ?? 
                                  'klokkin_media_${DateTime.now().millisecondsSinceEpoch}.json';
        final metadataPath = '${downloadDir.path}/$metadataFileName';
        final metadataFile = File(metadataPath);
        if (await metadataFile.exists()) {
          await metadataFile.delete();
        }
      } catch (cleanupError) {
        print('Error during cleanup: $cleanupError');
      }
      return false;
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