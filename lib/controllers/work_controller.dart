import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class WorkCardController extends GetxController {
  late VideoPlayerController videoController;
  var isPlaying = false.obs;
  var isInitialized = false.obs;

  void setVideoPath(String videoUrl) {
    videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..initialize().then((_) {
        isInitialized.value = true;
        update();
      });
  }

  void togglePlayPause() {
    if (isPlaying.value) {
      videoController.pause();
    } else {
      videoController.play();
    }
    isPlaying.value = !isPlaying.value;
  }

  @override
  void onClose() {
    videoController.dispose();
    super.onClose();
  }
}
