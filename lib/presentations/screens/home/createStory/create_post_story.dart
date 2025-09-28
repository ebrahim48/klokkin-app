import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import 'package:klokkin_app/presentations/widgets/custom_button.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';

import '../../../../controllers/home_controller.dart';
import '../../../../controllers/upload_create_controller.dart';

class CreatePostStoryScreen extends StatelessWidget {
   CreatePostStoryScreen({super.key});

  HomeController homeController = Get.put(HomeController());

   final UploadCreateStoryController controller = Get.put(UploadCreateStoryController());

  @override
  Widget build(BuildContext context) {

    final Map routeData = GoRouterState.of(context).extra as Map;
    final String title = routeData["title"];
    final String script = routeData["script"];
    final List<String> tags = List<String>.from(routeData["tags"]);
    final images = routeData["images"];
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),
            CustomText(
              textAlign: TextAlign.start,
              text:
              "All set! Share your story\nand let others feel your\njourney.",
              fontsize: 20.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textColor8B8B8B,
              maxline: 3,
            ),

            SizedBox(height: 16.h),
            const Divider(
              color: AppColors.primaryColorC79235,
            ),
            SizedBox(height: 16.h),
            Align(
              alignment: Alignment.centerRight,
              child: CustomText(
                textAlign: TextAlign.start,
                text:
                "Every story has a\nheartbeat. Let\nyours be heard\ntoday.",
                fontsize: 20.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor8B8B8B,
                maxline: 4,
              ),
            ),
            SizedBox(height: 60.h),

            /// ============================= Story Card =============================
            Center(
              child: Container(
                width: 94.w,
                height: 146.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF323539),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Container(
                    width: 82.w,
                    height: 126.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF20272E),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Image
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(4.r)),
                          child: Image.asset(
                            "assets/images/imageStory.png",
                            width: 82.w,
                            height: 70.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 6.h),

                        /// Title
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          child: CustomText(
                            text: "Innovation",
                            fontsize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.buttonColorE8A533,
                            maxline: 1,
                          ),
                        ),

                        /// Description
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          child: CustomText(
                            text: "In this unique\nworkspace.",
                            fontsize: 10.sp,
                            fontWeight: FontWeight.w300,
                            color: AppColors.textColorFFFFFF,
                            maxline: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),
            CustomText(
              textAlign: TextAlign.center,
              text:
              "Your story is ready to inspire the world.\nJust one click, and it’s out there\n—waiting to be heard.",
              fontsize: 20.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textColor8B8B8B,
              maxline: 4,
            ),

            SizedBox(height: 30.h),
            Obx(()=>
               Align(
                alignment: Alignment.center,
                child: CustomButton(
                 loading:  homeController.uploadStoryLoading.value,
                  title: 'Post',
                  onpress: () {
                    homeController.uploadStory(
                      images: controller.images,
                      caption: title,
                      description: script,
                      tags: tags.join(","),
                      thumbnail: controller.thumbnail.value,
                      context: context,
                    );
                  },
                  width: 160,
                  color: AppColors.textColor323539,
                  titlecolor: AppColors.textColorFFFFFF,
                  borderRadius: 8.r,
                ),
              )),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }
}
