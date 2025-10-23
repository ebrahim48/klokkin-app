import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:klokkin_app/core/helpers/toast_message_helper.dart';
import 'package:path_provider/path_provider.dart';



class DownloadHelper {
  /// Downloads file using http and saves to app's document directory
  static Future<String?> downloadFile(String url, String fileName) async {
    try {
      // 1. Fetch file as bytes
      final response = await http.get(Uri.parse(url));
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
}