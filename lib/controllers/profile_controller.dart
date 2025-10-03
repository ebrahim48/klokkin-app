import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../services/api_client.dart';
import '../services/api_constants.dart';

class ProfileController extends GetxController{

  /// ================================> Privacy Policy  ==============================>

  RxBool getPrivacyPolicyLoading = false.obs;
  RxString value = "".obs;
  privacyPolicy() async {
    getPrivacyPolicyLoading(true);
    var response = await ApiClient.getData(ApiConstants.privacyEndPoint);
    if (response.statusCode == 200) {
      value.value = response.body['data']['attributes']['privacyPolicy'];
      getPrivacyPolicyLoading(false);
    } else if (response.statusCode == 404) {
      getPrivacyPolicyLoading(false);
    }
  }


  /// ================================> About Us  ==============================>

  RxBool getAboutUsLoading = false.obs;
  RxString about = "".obs;
  aboutUs() async {
    getAboutUsLoading(true);
    var response = await ApiClient.getData(ApiConstants.aboutEndPoint);
    if (response.statusCode == 200) {
      about.value = response.body['data']['attributes']['aboutUs'];
      getAboutUsLoading(false);
    } else if (response.statusCode == 404) {
      getAboutUsLoading(false);
    }
  }

  /// ================================> Terms Condition ==============================>

  RxBool getTermsConditionLoading = false.obs;
  RxString terms = "".obs;
  termsCondition() async {
    getTermsConditionLoading(true);
    var response = await ApiClient.getData(ApiConstants.termsEndPoint);
    if (response.statusCode == 200) {
      terms.value = response.body['data']['attributes']['termsConditions'];
      getTermsConditionLoading(false);
    } else if (response.statusCode == 404) {
      getTermsConditionLoading(false);
    }
  }


}