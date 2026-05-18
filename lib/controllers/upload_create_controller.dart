import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class UploadCreateStoryController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final RxList<File> images = <File>[].obs;
  static const int maxImages = 5;
  Rx<File?> thumbnail = Rx<File?>(null);

  Future<void> pickFile() async {
    // FileType.media = images AND videos (was FileType.image, which is
    // why video files could never be selected here).
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
      type: FileType.media,
    );

    if (result == null) return;
    for (final f in result.files) {
      if (images.length >= maxImages) break;
      if (f.path != null) images.add(File(f.path!));
    }
    images.refresh();
  }

  Future<void> pickImageFromGallery() async {
    // pickMedia() lets the user choose an image OR a video from the
    // gallery (pickImage() was image-only).
    final XFile? media = await _picker.pickMedia();
    if (media != null && images.length < maxImages) {
      images.add(File(media.path));
      images.refresh();
    }
  }

  Future<void> takePhotoOrVideo(BuildContext context) async {
    final option = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Choose media type"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, "photo"),
            child: const Text("📷 Photo"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, "video"),
            child: const Text("🎥 Video"),
          ),
        ],
      ),
    );

    XFile? media;

    if (option == "photo") {
      media = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
    } else if (option == "video") {
      media = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(seconds: 60),
      );
    }

    if (media != null && images.length < maxImages) {
      images.add(File(media.path));
      update();
    }
  }



  void deleteImage(int index) {
    images.removeAt(index);
  }

  Future<void> editImage(int index) async {
    final XFile? newImage = await _picker.pickImage(source: ImageSource.gallery);
    if (newImage != null) {
      images[index] = File(newImage.path);
      images.refresh();
      print("✅ Image replaced at index $index: ${newImage.path}");
    }
  }



}
