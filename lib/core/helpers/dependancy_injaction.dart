import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:klokkin_app/controllers/home_controller.dart';

import '../../controllers/profile_controller.dart';
import '../../presentations/controller/auth_controller.dart';


class DependencyInjection implements Bindings {

  DependencyInjection();

  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);

  }

  void lockDevicePortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}