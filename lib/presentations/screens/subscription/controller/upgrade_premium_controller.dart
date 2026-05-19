import 'package:get/get.dart';

import '../../../../controllers/subscription_controller.dart';

class UpgradePremiumController extends GetxController {
  late final SubscriptionController sub;

  @override
  void onInit() {
    super.onInit();
    sub = Get.put(SubscriptionController());
    sub.loadAll();
  }
}
