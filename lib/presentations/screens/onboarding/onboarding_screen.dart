import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/presentations/widgets/custom_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/config/app_routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../global/custom_assets/assets.gen.dart';
import '../../widgets/custom_text.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.r),
          child: Stack(
            children: [
              /// =============================> Background Image with PageView ========================================>
              PageView.builder(
                controller: _pageController,
                itemCount: images.length,
                onPageChanged: (index) => indicatorIndex.value = index,
                itemBuilder: (context, index) {
                  return images[index].image(
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  );
                },
              ),

              /// ==================================>  Bottom overlay content =======================================>
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.9),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      /// =======================================> Text ========================================>
                      Obx(() => CustomText(
                        text: titles[indicatorIndex.value],
                        textAlign: TextAlign.start,
                        fontsize: 30.sp,
                        maxline: 2,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColorFFFFFF,
                      )),
                      SizedBox(height: 12.h),
                      Obx(() => CustomText(
                        text: subtitles[indicatorIndex.value],
                        textAlign: TextAlign.start,
                        fontsize: 16.sp,
                        color: AppColors.textColorFFFFFF,
                        maxline: 3,
                      )),
                      SizedBox(height: 24.h),
                      /// ======================================> Indicator =======================================>
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: images.length,
                        effect: ExpandingDotsEffect(
                          dotWidth: 13.w,
                          dotHeight: 9.h,
                          spacing: 8.w,
                          activeDotColor: AppColors.primaryColorC79235,
                          dotColor: AppColors.textColorFFFFFF,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      /// ======================================> Icon ==========================================>
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            if (indicatorIndex.value < images.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              context.pushNamed(AppRoutes.signUpScreen);

                            }
                          },

                        ),
                      ),
                      CustomButton(
                          title: 'Let’s get started',
                          onpress: () {

                          },)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  final PageController _pageController = PageController();
  var indicatorIndex = 0.obs;

  final List<AssetGenImage> images = [
    // Assets.images.welcome1,
    // Assets.images.welcome2,
  ];

  final List<String> titles = [
    "Shop more for less and reduce food waste",
    "Donate and feed those in need",
  ];

  final List<String> subtitles = [
    "Save and transform food waste into food opportunity",
    "Connect with NGOs and help ensure good food goes to those who need it.",
  ];

}
