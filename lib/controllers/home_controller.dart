import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/config/app_routes/app_routes.dart';
import 'package:klokkin_app/models/my_story_model.dart';
import 'package:video_player/video_player.dart';
import '../../../services/api_client.dart';
import '../../../services/api_constants.dart';
import '../core/helpers/toast_message_helper.dart';
import '../models/all_tags_model.dart';
import '../models/latest_form_model.dart';
import '../models/profile_model.dart';
import '../models/story_single_model.dart';
import '../models/story_steps_model.dart';
import '../models/working_days_model.dart';

class HomeController extends GetxController {



  // ================================> All Tags  ==============================>


  RxBool getAllTagsLoading = false.obs;
  RxList<AllTagsModel> allTags = <AllTagsModel>[].obs;
  getAllTags()async{
    getAllTagsLoading(true);
    var response = await ApiClient.getData(ApiConstants.getAllTagsEndPoint);
    if(response.statusCode == 200){
      allTags.value = List<AllTagsModel>.from(response.body["data"]["attributes"]["tags"].
      map((x)=> AllTagsModel.fromJson(x)));


      getAllTagsLoading(false);
    }else{
      getAllTagsLoading(false);
    }
  }

  // ================================> Update Tags  ==============================>

  var loading = false.obs;

  Future<void> updateTag(String id,List<String> tags)
  async {
    loading.value = true;
    var body = {
      "tag": tags,
    };

    var response = await ApiClient.patchData(
      ApiConstants.updateTagEndPoint(id),
      body: body,
    );

    print("===========response body : ${response.body} \nand status code : ${response.statusCode}");

    if (response.statusCode == 200 ) {
      update();
      ToastMessageHelper.showToastMessage("${response.body["message"]}",title: 'Success');
    } else {
      ToastMessageHelper.showToastMessage("${response.body["message"]}", title: "fail");
    }

    loading.value = false;
  }



/// ================================> Upload Story  ==============================>


  RxBool uploadStoryLoading = false.obs;

  uploadStory({
     required List<File> images,
        String? caption,
        File? thumbnail,
        String? description,
        String? tags,
        required BuildContext context}) async {
    uploadStoryLoading(true);

    List<MultipartBody> photoList = [];

    for (var photos in images) {
      photoList.add(MultipartBody("files", photos));
    }
    List<MultipartBody> multipartBody = photoList ?? [];
    if (thumbnail != null) {
      multipartBody.add(MultipartBody("thumbnail", thumbnail));
    }

    var body = {
      "caption": "$caption",
      "description": "$description",
      "tags": "$tags",
    };
    var response = await ApiClient.postMultipartData(
        ApiConstants.uploadEndPoint, body,
        multipartBody: multipartBody);
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastMessageHelper.showToastMessage("${response.body["message"]}",title: "Success");
      context.pushNamed(AppRoutes.bottomNavbarScreen);
      update();
      uploadStoryLoading(false);
    }
    uploadStoryLoading(false);
  }



/// ================================> Latest form   ==============================>


  RxBool getLatestFormLoading = false.obs;
  RxList<LatestFormModel> latestForm = <LatestFormModel>[].obs;
  getLatestForm()async{
    getLatestFormLoading(true);
    var response = await ApiClient.getData(ApiConstants.getLatestFormEndPoint);
    if(response.statusCode == 200){
      latestForm.value = List<LatestFormModel>.from(response.body["data"]["attributes"]["data"].
      map((x)=> LatestFormModel.fromJson(x)));
      getLatestFormLoading(false);
    }else{
      getLatestFormLoading(false);
    }
  }



  /// ================================> My Stories   ==============================>

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
    print("**********************print here**************");
  }
  RxBool getMyStoryLoading = false.obs;
  RxList<MyStoryModel> myStory = <MyStoryModel>[].obs;
  getMyStory()async{
    if(page.value == 1){
      loading(true);
    }
    getMyStoryLoading(true);
    var response = await ApiClient.getData(ApiConstants.getMyStoryEndPoint("${page.value}"));
    if(response.statusCode == 200){

      // totalPages = jsonDecode(response.body['pagination']['totalPages'].toString()) ?? 0;
      // currentPage = jsonDecode(response.body['pagination']['currentPage'].toString()) ?? 0;
      // total = jsonDecode(response.body['pagination']['total'].toString()) ?? 0;

      myStory.value = List<MyStoryModel>.from(response.body["data"]["attributes"]["data"].
      map((x)=> MyStoryModel.fromJson(x)));

      getMyStoryLoading(false);
    }else{
      getMyStoryLoading(false);
    }
  }


  /// ================================> Working Days   ==============================>


  RxBool getWorkingLoading = false.obs;
  RxList<WorkingDaysModel> workingDays = <WorkingDaysModel>[].obs;
  getWorkingDays()async{
    getWorkingLoading(true);
    var response = await ApiClient.getData(ApiConstants.getWorkingDaysEndPoint);
    if(response.statusCode == 200){
      workingDays.value = List<WorkingDaysModel>.from(response.body["data"]["attributes"]["data"].
      map((x)=> WorkingDaysModel.fromJson(x)));
      update();
      getWorkingLoading(false);
    }else{
      getWorkingLoading(false);
    }
  }


  /// ================================> Story   ==============================>


  RxBool getStoryStepsLoading = false.obs;
  RxList<StoryStepsModel> storySteps = <StoryStepsModel>[].obs;
  getStorySteps()async{
    getStoryStepsLoading(true);
    var response = await ApiClient.getData(ApiConstants.getStoryStepsEndPoint);
    if(response.statusCode == 200){
      storySteps.value = List<StoryStepsModel>.from(response.body["data"]["attributes"].
      map((x)=> StoryStepsModel.fromJson(x)));
      update();
      getStoryStepsLoading(false);
    }else{
      getStoryStepsLoading(false);
    }
  }

  /// ================================> Story Single  ==============================>


  RxBool getStorySingleLoading = false.obs;
  Rx<StorySingleModel> storySingle = StorySingleModel().obs;
  getStorySingle({String? id})async{
    getStorySingleLoading(true);
    var response = await ApiClient.getData(ApiConstants.getStorySingleEndPoint(id!));
    if(response.statusCode == 200){
      storySingle.value = StorySingleModel.fromJson(response.body['data']['attributes']);
      update();
      getStorySingleLoading(false);
    }else{
      getStorySingleLoading(false);
    }
  }


  /// ================================> Share  ==============================>

  var shareLoading = false.obs;
  share(String storyId) async {

    var body = {
      'story':storyId,
    };
    shareLoading(true);
    var response = await ApiClient.postData(
        ApiConstants.shareEndPoint,
        jsonEncode(body));
    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastMessageHelper.showToastMessage("${response.body["message"]}");
      update();
    } else {
      shareLoading(false);
    }
    shareLoading(false);

  }





  /// ================================>  Profile ==============================>

  RxBool getProfileLoading = false.obs;
  Rx<UserProfileModel> profile = UserProfileModel().obs;
  getProfile() async {
    getProfileLoading(true);
    var response = await ApiClient.getData(ApiConstants.userProfileEndPoint);
    if (response.statusCode == 200) {
      profile.value = UserProfileModel.fromJson(response.body['data']['attributes']);
      update();
      getProfileLoading(false);
    } else if (response.statusCode == 404) {
      getProfileLoading(false);
    }
  }


  /// ================================> Update Profile ==============================>


  var updateProfileLoading = false.obs;

  updateProfile({
    String? aboutself,
    String? nickname,
    gender,
    dateofBirth,
     File? file,
    required BuildContext context

  }) async {

    updateProfileLoading(true);

    List<MultipartBody> multipartBody = [];
    if (file != null) {
      multipartBody.add(MultipartBody("file", file));
    }



    var body = {
      "aboutself": "$aboutself",
      "nickname": "$nickname",
      "gender": "$gender",
      "dateofBirth": "$dateofBirth",
    };


    updateProfileLoading(true);

    var response = await ApiClient.patchMultipartData(
      ApiConstants.userUpdateProfileEndPoint,
      body,
        multipartBody: multipartBody
    );



    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastMessageHelper.showToastMessage("${response.body["message"]}");
      await getProfile();

      updateProfileLoading(false);
      context.pop();
      update();
    }

    else {
      updateProfileLoading(false);
      // ToastMessageHelper.showToastMessage("Failed Update data.");
    }
  }


  ///=============== Delete Account ================<>


  var deleteLoading = false.obs;
  deleteProfile(BuildContext context) async {

    deleteLoading(true);
    var response = await ApiClient.deleteData(
        ApiConstants.deleteProfileEndPoint);
    if (response.statusCode == 200) {
      ToastMessageHelper.showToastMessage('Account Delete Successfully');
      context.pushNamed(AppRoutes.logInScreen);
    } else {
      deleteLoading(false);
    }

  }


  /// ================================> Feedback  ==============================>


  var feedbackLoading = false.obs;

  feedback({
    String? comment,
    File? file,
    required BuildContext context

  }) async {

    feedbackLoading(true);

    List<MultipartBody> multipartBody = [];
    if (file != null) {
      multipartBody.add(MultipartBody("file", file));
    }



    var body = {
      "comment": "$comment",
    };


    feedbackLoading(true);

    var response = await ApiClient.postMultipartData(
        ApiConstants.feedbackEndPoint,
        body,
        multipartBody: multipartBody
    );



    if (response.statusCode == 200 || response.statusCode == 201) {
      ToastMessageHelper.showToastMessage("${response.body["message"]}");


      feedbackLoading(false);
      context.pop();
      update();
    } else {
      feedbackLoading(false);
      ToastMessageHelper.showToastMessage("Failed feedback data.");
    }
  }





















  /// Store controllers for each story
  Map<String, VideoPlayerController> videoControllers = {};
  Map<String, bool> playStates = <String, bool>{}.obs;
  Map<String, bool> isInitializedStates = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void setVideoPath(String storyId, String videoUrl) {
    // Dispose previous controller if exists
    if (videoControllers.containsKey(storyId)) {
      videoControllers[storyId]?.dispose();
    }

    videoControllers[storyId] = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..initialize().then((_) {
        isInitializedStates[storyId] = true;
        update();
      });
  }

  void togglePlayPause(String storyId) {
    if (!videoControllers.containsKey(storyId)) return;

    if (playStates[storyId] == true) {
      videoControllers[storyId]?.pause();
    } else {
      videoControllers[storyId]?.play();
    }
    playStates[storyId] = !(playStates[storyId] ?? false);
  }

  void disposeController(String storyId) {
    if (videoControllers.containsKey(storyId)) {
      videoControllers[storyId]?.dispose();
      videoControllers.remove(storyId);
      playStates.remove(storyId);
      isInitializedStates.remove(storyId);
    }
  }

  @override
  void onClose() {
    // Dispose all controllers
    videoControllers.values.forEach((controller) => controller.dispose());
    videoControllers.clear();
    super.onClose();
  }


}