import 'dart:async';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

enum RecordType { audio, video }

class RecordStoryController extends GetxController {
  var selectedType = RecordType.audio.obs;

  void switchTo(RecordType type) => selectedType.value = type;

  Timer? _timer;
  RxInt _recordDuration = 0.obs; // in seconds

  String get formattedDuration {
    int seconds = _recordDuration.value % 60;
    int minutes = (_recordDuration.value ~/ 60) % 60;
    int hours = _recordDuration.value ~/ 3600;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  final _recorder = AudioRecorder();
  RxBool isRecording = false.obs;
  RxString recordPath = ''.obs;

var path=getApplicationDocumentsDirectory();

  Future<void> startRecording() async {
    bool hasPerm = await _recorder.hasPermission();
    if (!hasPerm) {

      return;
    }

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/record_${DateTime.now().millisecondsSinceEpoch}.mp3';

    var config = RecordConfig();

    try {
      await _recorder.start(config, path: filePath);
      isRecording.value = true;

      // Start timer
      _timer?.cancel();
      _recordDuration.value = 0;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _recordDuration.value++;
      });
    } catch (e) {
      print('Error starting recording: $e');
      isRecording.value = false;
    }
  }

  Future<void> stopRecording() async {
    _timer?.cancel(); // Stop the timer

    try {
      final path = await _recorder.stop();
      isRecording.value = false;
      if (path != null) {
        recordPath.value = path;
        print("✅ Recording saved at: $path");
      }
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    _recorder.dispose();
    super.onClose();
  }



}
