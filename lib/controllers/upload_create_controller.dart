import 'dart:io';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class UploadCreateStoryController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final RxList<File> images = <File>[].obs;
  static const int maxImages = 5;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: true,
      type: FileType.image,
    );

    if (result != null && images.length < maxImages) {
      images.add(File(result.files.single.path!));
    }
  }

  Future<void> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null && images.length < maxImages) {
      images.add(File(image.path));
    }
  }

  Future<void> takePhotoOrVideo() async {
    final XFile? media = await _picker.pickImage(source: ImageSource.camera);
    if (media != null && images.length < maxImages) {
      images.add(File(media.path));
    }
  }

  void deleteImage(int index) {
    images.removeAt(index);
  }

  void editImage(int index) {
    // TODO: implement editing (crop / replace)
    print("Edit image: ${images[index].path}");
  }
}
