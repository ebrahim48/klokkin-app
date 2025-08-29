import 'package:get/get.dart';

class AudioBookController extends GetxController {

  var isPlayingList = List.generate(6, (index) => false).obs;


  int? playingIndex;
  final List<Map<String, String>> audioBooks = [
    {
      "title": "Stories from the Desk",
      "subtitle": "Audio 1hr 30m",
      "image": "assets/images/audio.png",
    },
    {
      "title": "Legends of the Forest",
      "subtitle": "Audio 2hr 10m",
      "image": "assets/images/audio.png",
    },
    {
      "title": "Journey to the Stars",
      "subtitle": "Audio 45m",
      "image": "assets/images/audio.png",
    },
  ];

  void togglePlayPause(int index) {
    isPlayingList[index] = !isPlayingList[index];

    for (int i = 0; i < isPlayingList.length; i++) {
      if (i != index) {
        isPlayingList[i] = false;
      }
    }
  }
}
