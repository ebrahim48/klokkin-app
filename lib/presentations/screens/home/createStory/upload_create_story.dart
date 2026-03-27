import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/config/app_routes/app_routes.dart';

import '../../../../controllers/upload_create_controller.dart';
import '../../../../controllers/home_controller.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import 'package:klokkin_app/presentations/widgets/custom_button.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import '../../../widgets/pill_button_widget.dart';

class UploadCreateStoryScreen extends StatelessWidget {
  const UploadCreateStoryScreen({super.key});

  @override
  Widget build(BuildContext context) {


    final UploadCreateStoryController controller = Get.put(UploadCreateStoryController());
    final Map routeData = GoRouterState.of(context).extra as Map;
    final String title = routeData["title"];
    final String script = routeData["script"];
    final List<String> tags = List<String>.from(routeData["tags"]);
    return Scaffold(
      appBar: CustomAppBar(title: "${routeData["pageTitle"]}"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),
            CustomText(
              textAlign: TextAlign.start,
              text:
              "Bring your story to life with upload files – upload up to 5, 20 MB each.",
              fontsize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textColorFFFFFF,
              maxline: 2,
            ),
            SizedBox(height: 12.h),

            Obx(() => controller.images.isEmpty
                ? Container(
              width: 390.w,
              height: 244.h,
              margin: EdgeInsets.only(top: 16.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppColors.textColorFFFFFF,
                  width: 0.56.w,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: controller.pickImageFromGallery,
                      child: SvgPicture.asset(
                        'assets/icons/upload.svg',
                        width: 40.w,
                        height: 40.h,
                      ),
                    ),
                    SizedBox(height: 7.h),
                    CustomText(
                      text: 'Drag and drop files to upload',
                      color: AppColors.textColorFFFFFF,
                      fontsize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: 8.h),
                    PillButton(
                        label: "Select file",
                        width: 110.w,
                        height: 40.h,
                        onTap: controller.pickFile),
                    SizedBox(height: 12.h),
                    PillButton(
                      label: "Take photo or video",
                      width: 160.w,
                      height: 40.h,
                      onTap: () => controller.takePhotoOrVideo(context),
                    ),



                  ],
                ),
              ),
            )
                :
            ///========================================> Show Grid of uploaded images ================================>
            Container(
              width: 360.w,
              height: 245.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppColors.textColorFFFFFF,
                  width: 0.56.w,
                ),
              ),
              margin: EdgeInsets.only(top: 9.h),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 2.h,
                  childAspectRatio: 162 / 108,
                ),
                itemCount: controller.images.length <
                    UploadCreateStoryController.maxImages
                    ? controller.images.length + 1
                    : controller.images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(8.w),
                    child: index < controller.images.length
                        ? Stack(
                      children: [
                        Container(
                          width: 162.w,
                          height: 108.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(
                              color: const Color(0xFF8B682D),
                              width: 1.w,
                            ),
                            image: DecorationImage(
                              image: FileImage(
                                  controller.images[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4.h,
                          right: 32.w,
                          child: GestureDetector(
                            onTap: () =>
                                controller.editImage(index),
                            child: SvgPicture.asset(
                              'assets/icons/edit.svg',
                              width: 28.w,
                              height: 28.h,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4.h,
                          right: 4.w,
                          child: GestureDetector(
                            onTap: () =>
                                controller.deleteImage(index),
                            child: SvgPicture.asset(
                              'assets/icons/delete.svg',
                              width: 28.w,
                              height: 28.h,
                            ),
                          ),
                        ),
                      ],
                    )
                        : GestureDetector(
                      onTap: controller.pickImageFromGallery,
                      child: Container(
                        width: 162.w,
                        height: 108.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(
                            color: const Color(0xFF8B682D),
                            width: 1.w,
                          ),
                          color: const Color(0xFF43464B),
                        ),
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "Add more",
                              color: AppColors.textColor000000,
                              fontsize: 16.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            SizedBox(height: 8.h),
                            SvgPicture.asset(
                              'assets/icons/PlusCircle.svg',
                              width: 28.w,
                              height: 28.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )),

            // TODO: Record Now — commented out until title/script re-entry issue is resolved
            // SizedBox(height: 32.h),
            // CustomText(
            //   text: 'Record your story to bring it to life.',
            //   color: AppColors.textColorFFFFFF,
            //   fontsize: 16.sp,
            //   fontWeight: FontWeight.w400,
            // ),
            // SizedBox(height: 16.h),
            // CustomButton(
            //   title: 'Record Now',
            //   onpress: () {
            //     final homeController = Get.find<HomeController>();
            //     homeController.pendingTitle.value = title;
            //     homeController.pendingDescription.value = script;
            //     context.pushNamed(AppRoutes.recordStoryScreen);
            //   },
            //   color: AppColors.textColorFFFFFF,
            //   titlecolor: AppColors.buttonColorE8A533,
            //   borderRadius: 8.r,
            // ),

            SizedBox(height: 145.h),
            Align(
              alignment: Alignment.center,
              child: OutlinedButton(
                onPressed: () {
                  context.pushNamed(
                      AppRoutes.createPostStoryScreen,
                    extra: {
                      "title": title,
                      "script": script,
                      "tags": tags,
                      "images": controller.images,
                    }

                  );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.buttonColorE8A533,
                  side: BorderSide(
                    color: AppColors.buttonColorE8A533,
                    width: 2.w,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  padding:
                  EdgeInsets.symmetric(horizontal: 46.w, vertical: 12.h),
                ),
                child: CustomText(
                  text: "Next",
                  color: AppColors.textColorFFFFFF,
                  fontsize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }
}
