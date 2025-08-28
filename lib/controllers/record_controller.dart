import 'package:get/get.dart';

enum RecordType { audio, video }

class RecordStoryController extends GetxController {
  var selectedType = RecordType.audio.obs;

  void switchTo(RecordType type) => selectedType.value = type;
}
