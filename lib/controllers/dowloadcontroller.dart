import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class DownloadController extends GetxController {
  RxBool isDownloading = false.obs;
  RxString downloadStatus = ''.obs;

  Future<void> downloadMedia({
    required String url,
    required String fileName,
  }) async {
    if (isDownloading.value) {
      print("Another download is in progress");
      return;
    }

    try {
      // Request permission
      if (!await _requestStoragePermission()) {
        print("Storage permission denied");
        downloadStatus.value = "Permission denied";
        return;
      }

      isDownloading.value = true;
      downloadStatus.value = "Downloading...";

      // Get temp directory
      Directory tempDir = await getTemporaryDirectory();
      String fileExtension = _getExtensionFromUrl(url);
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String finalFileName = '${_sanitizeFileName(fileName)}_$timestamp$fileExtension';
      final filePath = '${tempDir.path}/$finalFileName';

      print("Downloading: $url");
      print("Save path: $filePath");

      // Download file
      final httpClient = HttpClient();
      final request = await httpClient.getUrl(Uri.parse(url));
      final response = await request.close();

      if (response.statusCode == 200) {
        final file = File(filePath);
        final bytes = await consolidateHttpClientResponseBytes(response);
        await file.writeAsBytes(bytes);

        print("File downloaded, saving to gallery...");

        // Save to gallery
        final result = await ImageGallerySaverPlus.saveFile(
          filePath,
          name: finalFileName,
        );

        if (result != null && result['isSuccess'] == true) {
          print("✅ SUCCESS: File saved to Gallery");
          downloadStatus.value = "Downloaded successfully!";

          // Show success using GetX snackbar with key
          Get.rawSnackbar(
            title: "Success",
            message: "File downloaded to Gallery",
            backgroundColor: Colors.green,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 3),
          );
        } else {
          print("⚠️ File downloaded but gallery save unclear");
          downloadStatus.value = "Downloaded";
        }

        // Delete temp file
        try {
          await file.delete();
        } catch (e) {
          print("Could not delete temp file: $e");
        }
      } else {
        throw Exception('Download failed with status: ${response.statusCode}');
      }

      httpClient.close();
      isDownloading.value = false;

    } catch (e) {
      isDownloading.value = false;
      downloadStatus.value = "Download failed";
      print("❌ ERROR: $e");

      // Show error
      Get.rawSnackbar(
        title: "Download Failed",
        message: e.toString(),
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.photos.isGranted) return true;
      var photosStatus = await Permission.photos.request();
      if (photosStatus.isGranted) return true;

      if (await Permission.storage.isGranted) return true;
      var storageStatus = await Permission.storage.request();
      return storageStatus.isGranted;

    } else if (Platform.isIOS) {
      if (await Permission.photos.isGranted) return true;
      var status = await Permission.photos.request();
      return status.isGranted;
    }

    return false;
  }

  String _sanitizeFileName(String fileName) {
    return fileName.replaceAll(RegExp(r'[^\w\s\-_]'), '').trim();
  }

  String _getExtensionFromUrl(String url) {
    String cleanUrl = url.split('?').first.toLowerCase();

    if (cleanUrl.contains('.jpg') || cleanUrl.contains('.jpeg')) return '.jpg';
    if (cleanUrl.contains('.png')) return '.png';
    if (cleanUrl.contains('.gif')) return '.gif';
    if (cleanUrl.contains('.webp')) return '.webp';
    if (cleanUrl.contains('.mp4')) return '.mp4';
    if (cleanUrl.contains('.mov')) return '.mov';
    if (cleanUrl.contains('.avi')) return '.avi';

    return '.jpg';
  }
}