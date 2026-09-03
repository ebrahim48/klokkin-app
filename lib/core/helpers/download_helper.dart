import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:klokkin_app/core/helpers/toast_message_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:klokkin_app/core/helpers/prefs_helper.dart';



class DownloadHelper {
  /// Downloads file using http and saves to app's document directory
  static Future<String?> downloadFile(String url, String fileName) async {
    try {
      // 1. Fetch file as bytes with proper authentication
      Map<String, String> headers = {};

      // Check if it's an S3 URL that might need auth
      if (_isS3Url(url)) {
        final token = await PrefsHelper.getString('bearerToken');
        if (token.isNotEmpty) {
          headers['Authorization'] = token; // backend rejects a Bearer prefix
        }
      } else {
        // For non-S3 URLs, always try with auth
        final token = await PrefsHelper.getString('bearerToken');
        if (token.isNotEmpty) {
          headers['Authorization'] = token; // backend rejects a Bearer prefix
        }
      }

      // First try with headers
      http.Response response = await http.get(Uri.parse(url), headers: headers);

      // If that fails with 403, try without headers (for presigned URLs)
      if (response.statusCode == 403) {
        response = await http.get(Uri.parse(url)); // Without headers
      }

      if (response.statusCode != 200) {
        throw Exception('Failed to download: ${response.statusCode}');
      }

      // 2. Get app's document directory (private to your app)
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      // 3. Save file
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);


      ToastMessageHelper.showToastMessage("Downloaded: $fileName");


      return filePath;
    } catch (e) {
      ToastMessageHelper.showToastMessage("Download failed: $e",);
      return null;
    }
  }

  // Helper method to check if URL is an S3 URL
  static bool _isS3Url(String url) {
    return url.contains('.s3.') ||
           url.contains('s3.amazonaws.com') ||
           url.contains('s3-') ||
           url.contains('story-telling-bucket-s3');
  }
}