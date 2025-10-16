import 'package:get/get.dart';
import 'package:video_player/video_player.dart';



class WorkCardLibraryController extends GetxController {

  late VideoPlayerController videoController;
  var isPlaying = false.obs;
  var isInitialized = false.obs;

  void setVideoPath(String videoUrl) {
    videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..initialize().then((_) {
        isInitialized.value = true;
        videoController.setLooping(true);
      });
  }

  void togglePlayPause() {
    if (isPlaying.value) {
      videoController.pause();
    } else {
      videoController.play();
    }
    isPlaying.toggle();
  }

  @override
  void onClose() {
    videoController.dispose();
    super.onClose();
  }



}

