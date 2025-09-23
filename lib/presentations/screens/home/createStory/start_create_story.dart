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
                  }),
              SizedBox(height: 22.h),
              CustomButton(
                title: 'Record Now',
                onpress: () {
                  context.pushNamed(AppRoutes.recordStoryScreen,
                  );

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
              SizedBox(height: 124.h),
              CustomText(
                text: 'To create story, you must complete three key steps that will guide you from start to finish.',
                fontsize: 16.sp,
                fontWeight: FontWeight.w400,
                color:  AppColors.textColorFFFFFF,
                maxline: 2,
              ),
              SizedBox(height: 32.h),  /// ===================================> START CARDS ====================================>
              SizedBox(
                height: 200.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: steps.length,
                  separatorBuilder: (_, __) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    final step = steps[index];
                    return StoryCard(
                      step: step["step"]!,
                      desc: step["desc"]!,
                    );
                  },
                ),
              ),

              SizedBox(height: 15.h),


              SizedBox(height: 50.h)
            ],
          ),
        ),
      ),
    );
  }

  final List<Map<String, String>> steps = [
    {
      "step": "Step 1",
      "desc":
      "At first, enter your story’s title, add a short description, and select tags to make it easier to find.",
    },
    {
      "step": "Step 2",
      "desc":
      "Next, upload your media or record directly in the app to bring your story to life.",
    },
    {
      "step": "Step 3",
      "desc":
      "Finally, review your story and publish it to share with your audience.",
    },
  ];
}







