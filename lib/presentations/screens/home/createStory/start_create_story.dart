import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/config/app_routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/story_card_widget.dart';


class StartCreateStoryScreen extends StatefulWidget {
  StartCreateStoryScreen({super.key});

  @override
  State<StartCreateStoryScreen> createState() => _StartCreateStoryScreenState();
}

class _StartCreateStoryScreenState extends State<StartCreateStoryScreen> {
  @override
  Widget build(BuildContext context) {
    Map routeData = GoRouterState.of(context).extra as Map;
    return Scaffold(
      appBar: CustomAppBar(title: "${routeData["title"]}"),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 66.h),

              /// ============================================ Button ====================================>

              CustomButton(title: "Create My Story",
                  onpress: () {
                    context.pushNamed(AppRoutes.nextCreateStoryScreen, extra: {
                      "title" : "Create a story",

                    });
                    // Get.toNamed(AppRoutes.optScreen, arguments: {"screenType" : "Sign up"});
                  }),
              SizedBox(height: 22.h),
              CustomButton(
                title: 'Record Now',
                onpress: () {


                },
                color: AppColors.textColorFFFFFF,
                titlecolor: AppColors.buttonColorE8A533,
                borderRadius: 8.r,
                borderColor: AppColors.buttonColorE8A533,
              ),
              SizedBox(height: 32.h),
              Align(
                alignment: Alignment.center,
                child: CustomText(
                  text: 'Record your story in the Klokk-in app',
                  fontsize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color:  AppColors.buttonColorE8A533,
                ),
              ),
              SizedBox(height: 115.h),  /// ===================================> START CARDS ====================================>
              SizedBox(
                height: 300.h,
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.85),
                  itemCount: stories.length,
                  itemBuilder: (context, index) {
                    final story = stories[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: StoryCard(
                        image: story["image"]!,
                        title: story["title"]!,
                        desc: story["desc"]!,
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 15.h),
              /// =============================> Page Indicator =============================>
              Align(
                alignment: Alignment.center,
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: stories.length,
                  effect: ExpandingDotsEffect(
                    dotWidth: 10.w,
                    dotHeight: 6.h,
                    spacing: 6.w,
                    activeDotColor: AppColors.primaryColorC79235,
                    dotColor: AppColors.textColorFFFFFF,
                  ),
                ),
              ),


              SizedBox(height: 50.h)
            ],
          ),
        ),
      ),
    );
  }

  final PageController _pageController = PageController();

  var indicatorIndex = 0.obs;

  final List<Map<String, String>> stories = [
    {
      "image": "assets/images/create.png",
      "title": "Innovation Finds Its Space",
      "desc":
      "In this modern workspace, ideas flow freely. Every desk holds the start of a new story.",
    },
    {
      "image": "assets/images/create.png",
      "title": "Collaboration Zone",
      "desc": "Work together, share ideas, and create something amazing every day.",
    },
    {
      "image": "assets/images/create.png",
      "title": "Creative Hub",
      "desc": "This space fuels creativity and sparks innovation for every team.",
    },
  ];
}







