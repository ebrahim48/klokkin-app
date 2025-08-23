import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../presentations/screens/auth/forget/forget_password_screen.dart';
import '../../../presentations/screens/auth/signIn/sign_in_screen.dart';
import '../../../presentations/screens/auth/signup/sign_up_screen.dart';
import '../../../presentations/screens/onboarding/onboarding_screen.dart';
import '../../../presentations/screens/splash/splash_screen.dart';


class AppRoutes {

  static const String splashScreen = "/splashScreen";
  static const String onBoardingScreen = "/onBoardingScreen";

  /// =============================> Auth ================================>

  static const String signUpScreen = "/signUpScreen";
  static const String logInScreen = "/logInScreen";
  static const String forgetPasswordScreen = "/forgetPasswordScreen";
  static const String verifyScreen = "/verifyScreen";
  static const String resetPasswordScreen = "/resetPasswordScreen";

  /// ============================> Customer ================================>

  static const String customerHomeScreen = "/customerHomeScreen";



  static final GoRouter goRouter =
  GoRouter(initialLocation: splashScreen, routes: [


    GoRoute(
      path: splashScreen,
      name: splashScreen,
      builder: (context, state) => const SplashScreen(),
      redirect: (context, state) {
        Future.delayed(const Duration(seconds: 3), () async {
          // var role = await PrefsHelper.getString(AppConstants.role);
          // var token = await PrefsHelper.getString(AppConstants.bearerToken);
          // var userId = await PrefsHelper.getString(AppConstants.userId);
          // var fcmToken = await PrefsHelper.getString(AppConstants.fcmToken);
          // bool isLogged = await PrefsHelper.getBool(AppConstants.isLogged);
          //
          //
          //
          // print("======================================$isLogged  \n token: $token \n userId : $userId \n fcm token : $fcmToken");
          //
          // SocketServices sockService = SocketServices();
          //
          // sockService.init(userId: userId, fcmToken: fcmToken.toString());
          // FirebaseNotificationService.listenMessage();
          //
          // if(token != "" && isLogged){
          //
          //   /// ===============Role Check =============>>>
          //   if(role.toLowerCase() == "customer"){
          //     AppRoutes.goRouter.replaceNamed(AppRoutes.customerBottomNavBar);
          //   }else if(role.toLowerCase() == "mechanic"){
          //     AppRoutes.goRouter.replaceNamed(AppRoutes.mechanicBottomNavBar);
          //   }else{
          //     AppRoutes.goRouter.replaceNamed(AppRoutes.towTruckBottomNavBar);
          //   }
          // }else{
          //   AppRoutes.goRouter.replaceNamed(AppRoutes.onboardingScreen);
          // }

          AppRoutes.goRouter.replaceNamed(AppRoutes.onBoardingScreen);

        }

        );

        return;
      },
    ),

    ///<<<=============>>> ONBOARDING SCREEN <<<===============>>>
    GoRoute(
      path: onBoardingScreen,
      name: onBoardingScreen,
      pageBuilder: (context, state) =>
          _customTransitionPage( OnboardingScreen(), state),
    ),
    /// =============================================================> Auth  =================================================>

    ///<<<=============>>> Sign Up SCREEN <<<===============>>>
    GoRoute(
      path: signUpScreen,
      name: signUpScreen,
      pageBuilder: (context, state) =>
          _customTransitionPage( SignUpScreen(), state),
    ),
    ///<<<=============>>> Log In <<<===============>>>
    GoRoute(
      path: logInScreen,
      name: logInScreen,
      pageBuilder: (context, state) =>
          _customTransitionPage( LoginScreen(), state),
    ),

    ///<<<=============>>> Forget Password Screen  <<<===============>>>
    GoRoute(
      path: forgetPasswordScreen,
      name: forgetPasswordScreen,
      pageBuilder: (context, state) =>
          _customTransitionPage( ForgetPasswordScreen(), state),
    ),


    // ///<<<=============>>> Verify Screen  <<<===============>>>
    // GoRoute(
    //   path: verifyScreen,
    //   name: verifyScreen,
    //   pageBuilder: (context, state) =>
    //       _customTransitionPage( VerifyScreen(), state),
    // ),
    //
    //
    // ///<<<=============>>> Reset Password Screen  <<<===============>>>
    // GoRoute(
    //   path: resetPasswordScreen,
    //   name: resetPasswordScreen,
    //   pageBuilder: (context, state) =>
    //       _customTransitionPage( ResetPasswordScreen(), state),
    // ),
    //
    // /// =============================================================> Customer =================================================>
    // ///<<<=============>>> Customer Home Screen  <<<===============>>>
    // GoRoute(
    //   path: customerHomeScreen,
    //   name: customerHomeScreen,
    //   pageBuilder: (context, state) =>
    //       _customTransitionPage( CustomerHomeScreen(), state),
    // ),



  ]);





  static Page<dynamic> _customTransitionPage(
      Widget child, GoRouterState state) {

    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
