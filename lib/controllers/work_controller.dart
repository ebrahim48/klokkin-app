import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class WorkCardController extends GetxController {
  late VideoPlayerController controller;
  var isPlaying = false.obs;

  @override
  void onInit() {
    super.onInit();
    controller = VideoPlayerController.asset('')
      ..initialize().then((_) {
        update();
      });
  }

  void setVideoPath(String videoPath) {
    controller = VideoPlayerController.asset(videoPath)
      ..initialize().then((_) {
        update();
      });
  }

  void togglePlayPause() {
    if (isPlaying.value) {
      controller.pause();
    } else {
      controller.play();
    }
    isPlaying.value = !isPlaying.value;
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }



}
