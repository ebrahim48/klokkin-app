import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../../services/api_client.dart';
import '../../../services/api_constants.dart';
import '../models/all_tags_model.dart';

class HomeController extends GetxController {



  // ================================> All Tags  ==============================>


  RxBool getAllTagsLoading = false.obs;
  Rx<AllTagsModel> allTags = AllTagsModel().obs;
  getAllTags() async {
    getAllTagsLoading(true);
    var response = await ApiClient.getData(ApiConstants.getAllTagsEndPoint);
    if (response.statusCode == 200) {
      allTags.value = AllTagsModel.fromJson(response.body["data"]["attributes"]);
      getAllTagsLoading(false);
    } else if (response.statusCode == 404) {
      getAllTagsLoading(false);
    }
  }


















}