import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:klokkin_app/core/helpers/network_connection.dart';
import 'package:toastification/toastification.dart';
import 'core/config/app_routes/app_routes.dart';
import 'core/config/app_themes/app_themes.dart';
import 'core/helpers/dependancy_injaction.dart';
import 'presentations/controller/theme_controller.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PlatformDispatcher.instance.onAccessibilityFeaturesChanged = () {};
  DependencyInjection di = DependencyInjection();
  di.dependencies();
  di.lockDevicePortrait();

  Get.put(ThemeController());
  runApp(
    DevicePreview(

      enabled:false,
      builder: (context) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: ScreenUtilInit(
          designSize: const Size(393, 852),
          builder: (context, child) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Klokkin App',
              theme: Themes().lightTheme,
              darkTheme: Themes().lightTheme,
              useInheritedMediaQuery: true,
              locale: DevicePreview.locale(context),
              themeMode: Get.find<ThemeController>().themeMode.value,
              routeInformationParser: AppRoutes.goRouter.routeInformationParser,
              routeInformationProvider:
              AppRoutes.goRouter.routeInformationProvider,
              routerDelegate: AppRoutes.goRouter.routerDelegate,
              builder: (context, child) {
                return Scaffold(body: NoInterNetScreen(child: child!));
              },
            );
          }),
    );
  }
}












//
// import 'dart:ui';
// import 'package:flutter/foundation.dart'; // Add this
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:klokkin_app/core/helpers/network_connection.dart';
// import 'package:toastification/toastification.dart';
// import 'core/config/app_routes/app_routes.dart';
// import 'core/config/app_themes/app_themes.dart';
// import 'core/helpers/dependancy_injaction.dart';
// import 'presentations/controller/theme_controller.dart';
// import 'package:device_preview/device_preview.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   PlatformDispatcher.instance.onAccessibilityFeaturesChanged = () {};
//   DependencyInjection di = DependencyInjection();
//   di.dependencies();
//   di.lockDevicePortrait();
//
//   Get.put(ThemeController());
//
//
//   runApp(
//     DevicePreview(
//       enabled: !kReleaseMode, // Enable in debug mode only
//       builder: (context) => MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ToastificationWrapper(
//       child: ScreenUtilInit(
//           designSize: const Size(393, 852),
//           builder: (context, child) {
//             return MaterialApp.router(
//               debugShowCheckedModeBanner: false,
//               title: 'Klokkin App',
//               theme: Themes().lightTheme,
//               darkTheme: Themes().lightTheme,
//               useInheritedMediaQuery: true,
//               locale: DevicePreview.locale(context),
//               themeMode: Get.find<ThemeController>().themeMode.value,
//               routeInformationParser: AppRoutes.goRouter.routeInformationParser,
//               routeInformationProvider:
//               AppRoutes.goRouter.routeInformationProvider,
//               routerDelegate: AppRoutes.goRouter.routerDelegate,
//               builder: (context, child) {
//                 // Combine DevicePreview builder with your NoInterNetScreen
//                 child = DevicePreview.appBuilder(context, child);
//                 return Scaffold(body: NoInterNetScreen(child: child));
//               },
//             );
//           }),
//     );
//   }
// }










