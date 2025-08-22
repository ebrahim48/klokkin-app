import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ============ Title ============
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Welcome",
                    fontsize: 40.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColorC79235,
                  ),
                  SizedBox(height: 8.h),
                  CustomText(
                    textAlign: TextAlign.start,
                    maxline: 2,
                    text: "Discover, Create & Share Amazing Stories.",
                    fontsize: 20.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondary836531,
                  ),
                ],
              ),
            ),

            /// ============ Images + Lines ============
            Expanded(
              child: Stack(
                children: [
                  /// Left Image

                  Positioned(
                    left: 1.w,
                    top: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(4.r),
                        bottomRight: Radius.circular(4.r),
                      ),
                      child: Image.asset(
                        images[0],
                        width: 248.w,
                        height: 160.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  /// Right Image

                  Positioned(
                    right: 1.w,
                    top: 172.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(4.r),
                        topLeft: Radius.circular(4.r),
                      ),
                      child: Image.asset(
                        images[1],
                        width: 248.w,
                        height: 160.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  /// ====== Vertical Line  ======
                  Positioned(
                    top: 0,
                    left: MediaQuery.of(context).size.width / 1 - 139.w,
                    child: Container(
                      width: 1,
                      height: 167.h,
                      color: AppColors.primaryColorC79235,
                    ),
                  ),

                  /// ====== Horizontal Line  ======
                  Positioned(
                    top: 166.h,
                    left: MediaQuery.of(context).size.width / 2 - 57.w,
                    right: MediaQuery.of(context).size.width / 2 - 58.w,
                    child: Container(
                      width: 82.w,
                      height: 1,
                      color: AppColors.primaryColorC79235,
                    ),
                  ),

                  /// ====== Vertical Line 3  ======
                  Positioned(
                    top: 167.h,
                      left: MediaQuery.of(context).size.width / 2 - 57.w,
                    child: Container(
                        width: 1,
                        height: 165.h,
                      color: AppColors.primaryColorC79235)),
                ],
              ),
            ),

            /// ============ Bottom Section ============
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                children: [
                  CustomButton(
                    title: "Let’s get started",
                    onpress: () {
                      // context.pushNamed(AppRoutes.signUpScreen);
                    },
                  ),
                  SizedBox(height: 120.h),
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: images.length,
                    effect: ExpandingDotsEffect(
                      dotWidth: 16.w,
                      dotHeight: 8.h,
                      spacing: 6.w,
                      activeDotColor: AppColors.primaryColorC79235,
                      dotColor: AppColors.textColorFFFFFF,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  final PageController _pageController = PageController();
  var indicatorIndex = 0.obs;

  final List<String> images = [
    "assets/images/welcome1.png",
    "assets/images/welcome2.png",
    "assets/images/welcome2.png",
  ];



}
