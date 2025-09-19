import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/config/app_routes/app_routes.dart';
import '../../../services/api_client.dart';
import '../../../services/api_constants.dart';
import '../core/helpers/toast_message_helper.dart';
import '../models/all_tags_model.dart';
import '../models/latest_form_model.dart';

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

  uploadStory(
      { required List<File> images,
        String? caption,
        String? type,
        String? description,
        String? tags,
        required BuildContext context}) async {
    uploadStoryLoading(true);

    List<MultipartBody> photoList = [];
    for (var photos in images) {
      photoList.add(MultipartBody("files", photos));
    }
    List<MultipartBody> multipartBody = photoList ?? [];

    var body = {
      "caption": "$caption",
      "type": "$type",
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



// ================================> Latest form   ==============================>


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











}