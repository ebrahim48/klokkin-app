import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_constants/app_constants.dart';
import '../../../core/config/app_routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/helpers/prefs_helper.dart';
import '../../../global/custom_assets/assets.gen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();


    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    String token = await PrefsHelper.getString(AppConstants.bearerToken);
    bool isLogged = await PrefsHelper.getBool(AppConstants.isLogged);

    if (mounted) {
      if (token.isNotEmpty && isLogged) {
        context.go(AppRoutes.bottomNavbarScreen);
      } else {
        context.go(AppRoutes.onBoardingScreen);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.bgColor,
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 247.h),
              Assets.images.splashImage.image(
                  width: 341.w,
                  height: 341.h
              ),
            ],
          ),
        )
    );
  }
}