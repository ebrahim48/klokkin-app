import 'dart:convert';

import 'package:get/get.dart';

import '../core/helpers/toast_message_helper.dart';
import '../models/story_libray_data_model.dart';
import '../services/api_client.dart';
import '../services/api_constants.dart';

class AudioBookController extends GetxController {

  /// ================================> Library Stories   ==============================>

  Rxn<Meta> audioMeta = Rxn<Meta>();
  Rxn<Meta> videoMeta = Rxn<Meta>();
  Rxn<Meta> imageMeta = Rxn<Meta>();

  RxInt page = 1.obs;
  var totalPages = (-1);
  var currentPage = (-1);
  var total = (-1);
  void loadMore() {
    print("==========================================total page ${totalPages} page No: ${page.value} == total result ${total}");
    if (totalPages > page.value) {
      page.value += 1;
      print("**********************print here");
      update();
    }
  }
  RxBool getLibraryStoryLoading = false.obs;
  RxList<StoryLibraryDataModel> libraryStoryData = <StoryLibraryDataModel>[].obs;
  getLibraryStoryData() async {
    if (page.value == 1) {
      getLibraryStoryLoading(true);
    }

    getLibraryStoryLoading(true);
    var response = await ApiClient.getData(ApiConstants.getStoryLibraryEndPoint);

    if (response.statusCode == 200) {
      final data = response.body["data"]["attributes"]["data"];

      final mergedStories = <StoryLibraryDataModel>[];

      // Collect audio
      final audioGroup = data["audio"];
      final audioResults = (data["audio"]["results"] as List?) ?? [];
      audioMeta.value = audioGroup?["meta"] != null ? Meta.fromJson(audioGroup["meta"]) : null;
      mergedStories.addAll(
        audioResults.map((x) => StoryLibraryDataModel.fromJson(x as Map<String, dynamic>)),
      );

      // Collect video
      final videoGroup = data["video"];
      final videoResults = (data["video"]["results"] as List?) ?? [];
      videoMeta.value = videoGroup?["meta"] != null ? Meta.fromJson(videoGroup["meta"]) : null;
      mergedStories.addAll(
        videoResults.map((x) => StoryLibraryDataModel.fromJson(x as Map<String, dynamic>)),
      );

      // Collect image
      final imageGroup = data["image"];
      final imageResults = (data["image"]["results"] as List?) ?? [];
      imageMeta.value = imageGroup?["meta"] != null ? Meta.fromJson(imageGroup["meta"]) : null;
      mergedStories.addAll(
        imageResults.map((x) => StoryLibraryDataModel.fromJson(x as Map<String, dynamic>)),
      );

      libraryStoryData.value = mergedStories;
    }

    getLibraryStoryLoading(false);
  }


  /// ============================> Update Story  ==================================>

  var updateStoryLoading = false.obs;
  updateStory(String storyId) async {

    var body = {
      'caption':storyId,
    };
    updateStoryLoading(true);
    var response = await ApiClient.patch(
        ApiConstants.updateStoryEndPoint(storyId),
        jsonEncode(body));
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastMessageHelper.showToastMessage("${response.body["message"]}");
    } else {

    }
    updateStoryLoading(false);

  }






  /// ============================> Bookmark ==================================>

  var bookMarkLoading = false.obs;
  bookMark(String storyId) async {

    var body = {
      'story':storyId,
    };
    bookMarkLoading(true);
    var response = await ApiClient.postData(
        ApiConstants.bookMarkEndPoint,
        jsonEncode(body));
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastMessageHelper.showToastMessage("${response.body["message"]}");
    } else {

    }
    bookMarkLoading(false);

  }



}
