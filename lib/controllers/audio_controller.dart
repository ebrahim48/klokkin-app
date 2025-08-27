import 'dart:async';
import 'package:get/get.dart';

class AudioController extends GetxController {
  var currentTime = 0.0.obs;
  var totalTime = 600.0.obs;
  var playbackSpeed = 1.0.obs;
  var isPlaying = false.obs;

  Timer? _timer;

  void togglePlayPause() {
    if (isPlaying.value) {
      _timer?.cancel();
      isPlaying.value = false;
    } else {
      isPlaying.value = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        currentTime.value += 1 * playbackSpeed.value;
        if (currentTime.value >= totalTime.value) {
          currentTime.value = totalTime.value;
          isPlaying.value = false;
          _timer?.cancel();
        }
      });
    }
  }

  void forward() {
    currentTime.value = (currentTime.value + 15).clamp(0, totalTime.value);
  }

  void seek(double value) {
    currentTime.value = value;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  String formatSpeed(double speed) {
    if (speed == speed.toInt()) {
      return "${speed.toInt()}X";
    } else {
      return "${speed.toStringAsFixed(1)}X";
    }
  }

  final List<String> hashtags = [
    "#innovation",
    "#tech",
    "#engineer",
    "#2010s",
  ];
}
