import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/config/app_routes/app_routes.dart';
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
            /// PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  indicatorIndex.value = index;
                },
                itemBuilder: (context, index) {
                  final page = pages[index];
                  /// ===========================> First PAGE ===================================>
                  if (index == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Title Section
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 20.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: page["title"]!,
                                fontsize: 40.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryColorC79235,
                              ),
                              SizedBox(height: 8.h),
                              CustomText(
                                textAlign: TextAlign.start,
                                maxline: 2,
                                text: page["subtitle"]!,
                                fontsize: 20.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.secondary836531,
                              ),
                            ],
                          ),
                        ),

                        /// Images + Lines
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
                                    page["image1"]!,
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
                                    page["image2"]!,
                                    width: 248.w,
                                    height: 160.h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                              /// Vertical Line
                              Positioned(
                                top: 0,
                                left: MediaQuery.of(context).size.width / 1 -
                                    139.w,
                                child: Container(
                                  width: 1,
                                  height: 167.h,
                                  color: AppColors.primaryColorC79235,
                                ),
                              ),

                              /// Horizontal Line
                              Positioned(
                                top: 166.h,
                                left: MediaQuery.of(context).size.width / 2 -
                                    57.w,
                                right: MediaQuery.of(context).size.width / 2 -
                                    58.w,
                                child: Container(
                                  width: 82.w,
                                  height: 1,
                                  color: AppColors.primaryColorC79235,
                                ),
                              ),

                              /// Vertical Line 3
                              Positioned(
                                top: 167.h,
                                left: MediaQuery.of(context).size.width / 2 -
                                    57.w,
                                child: Container(
                                    width: 1,
                                    height: 165.h,
                                    color: AppColors.primaryColorC79235),
                              ),
                            ],
                          ),
                        ),

                        /// Bottom Section
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 20.h),
                          child: CustomButton(
                            title: page["button"]!,
                            onpress: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  /// ===========================> SECOND PAGE ===================================>
                  else if(index == 1) {
                    return Stack(
                      children: [
                        /// Image
                        Positioned(
                          top: 72.h,
                          left: 44.w,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4.r),
                            child: Image.asset(
                              page["image1"]!,
                              width: 350.w,
                              height: 198.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        /// Horizontal Line
                        Positioned(
                          top: 280.h,
                          left: 0,
                          right: 16,
                          child: Container(
                            height: 1,
                            color: AppColors.primaryColorC79235,
                          ),
                        ),

                        /// Texts + Button
                        Positioned(
                          top: 300.h,
                          left: 20.w,
                          right: 20.w,
                          child: Column(
                            children: [
                              SizedBox(height: 60.h),
                              CustomText(
                                text: page["title"]!,
                                fontsize: 24.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryColorC79235,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 24.h),
                              CustomText(
                                text: page["subtitle"]!,
                                fontsize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.secondary836531,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 65.h),
                              Padding(
                                padding:  EdgeInsets.only(left: 100.w),
                                child: CustomButton(
                                  title: page["button"]!,
                                  onpress: () {
                                    _pageController.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  width: 240.w,
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// Vertical Line
                        Positioned(
                          height: 351.h,
                          top: 287.w,
                          right: MediaQuery.of(context).size.width / 2 -
                              180.w,
                          child: Container(
                            width: 1,
                            height: 120.h,
                            color: AppColors.primaryColorC79235,
                          ),
                        ),
                      ],
                    );
                  }
                  /// ===========================> THIRD PAGE (CREATE ACCOUNT) ==========================>
                  else {
                    return Stack(
                      children: [
                        /// First Image
                        Positioned(
                          top: 72.h,
                          left: 58.w,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4.r),
                            child: Image.asset(
                              page["image1"]!,
                              width: 208.w,
                              height: 151.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        /// Second Image
                        Positioned(
                          top: 72.h,
                          left: 255.w + 18.w,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4.r),
                            child: Image.asset(
                              page["image2"]!,
                              width: 85.w,
                              height: 151.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        /// Third Image
                        Positioned(
                          top: 230.h,
                          left: 146.w,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4.r),
                            child: Image.asset(
                              page["image3"]!,
                              width: 214.w,
                              height: 113.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        /// Horizontal Line
                        Positioned(
                          top: 230.h,
                          left: 60,
                          right: 231,
                          child: Container(
                            height: 1,
                            color: AppColors.primaryColorC79235,
                          ),
                        ),
                        /// Vertical Line 3
                        Positioned(
                          top: 166.h + 60,
                          left: MediaQuery.of(context).size.width / 2 - 57.w,
                          child: Container(
                              width: 1,
                              height: 113.h,
                              color: AppColors.primaryColorC79235),
                        ),
                        /// Texts + Button
                        Positioned(
                          top: 380.h,
                          left: 20.w,
                          right: 20.w,
                          child: Column(
                            children: [
                              CustomText(
                                text: page["title"]!,
                                fontsize: 24.sp,
                                maxline: 2,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColorC79235,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20.h),
                              CustomText(
                                text: page["subtitle"]!,
                                fontsize: 16.sp,
                                maxline: 2,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondary836531,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 75.h),
                              Padding(
                                padding: EdgeInsets.only(left: 90.w,),
                                child: CustomButton(
                                  title: page["button"]!,
                                  onpress: () {
                                    context.pushNamed(AppRoutes.signUpScreen);

                                  },

                                  width: 270.w,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 10.h),
            Center(
            child: SmoothPageIndicator(
                controller: _pageController,
                count: pages.length,
                effect: ExpandingDotsEffect(
                  dotWidth: 16.w,
                  dotHeight: 8.h,
                  spacing: 6.w,
                  activeDotColor: AppColors.primaryColorC79235,
                  dotColor: AppColors.textColorFFFFFF,
                ),
              ),
          ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }


  final PageController _pageController = PageController();
  var indicatorIndex = 0.obs;

  final List<Map<String, String>> pages = [
    {
      "image1": "assets/images/welcome1.png",
      "image2": "assets/images/welcome2.png",
      "title": "Welcome",
      "subtitle": "Discover, Create & Share Amazing Stories.",
      "button": "Let’s get started",
    },
    {
      "image1": "assets/images/splash.png",
      "title": "Your Next Favorite Story\nStarts Here...",
      "subtitle":
      "Step into a universe of stories.\nLet your imagination find\nit’s voice.",
      "button": "Continue",
    },
    {
      "image1": "assets/images/createAccountImage1.png",
      "image2": "assets/images/createAccountImage2.png",
      "image3": "assets/images/createAccountImage3.png",
      "title": "Start Your KLOKK-IN\nJourney Today",
      "subtitle": "Your stories and favorites will\nbe saved securely.",
      "button": "Create Account",
    },
  ];
}



























