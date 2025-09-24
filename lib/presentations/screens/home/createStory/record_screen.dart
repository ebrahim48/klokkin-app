import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/config/app_routes/app_routes.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import 'package:klokkin_app/presentations/widgets/custom_button.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import '../../../../controllers/record_controller.dart';
import '../../../../global/custom_assets/assets.gen.dart';
import '../../../widgets/waveform-painter.dart';

class RecordStoryScreen extends StatelessWidget {
  const RecordStoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RecordStoryController());

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            /// ================== Toggle Buttons Audio and Video ==================
            Obx(() {
              return Container(
                width: 200.w,
                height: 45.h,
                decoration: BoxDecoration(
                  color: AppColors.textColorFFFFFF,
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _tab(
                      text: "Audio",
                      isSelected: controller.selectedType.value == RecordType.audio,
                      onTap: () => controller.switchTo(RecordType.audio),
                    ),
                    _tab(
                      text: "Video",
                      isSelected: controller.selectedType.value == RecordType.video,
                      onTap: () => controller.switchTo(RecordType.video),
                   ),
                  ],
                  ),);}),
            SizedBox(height: 40.h),
            /// ================== Conditional View ==================
            Obx(() {
              if (controller.selectedType.value == RecordType.audio) {
                return _audioView();
              } else {
                return _videoView(
                  context

                );
              }
            }),
          ],
        ),
      ),
    );
  }

  /// ========== Toggle Button ==========
  Widget _tab({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColorC79235 : AppColors.textColorFFFFFF,
            borderRadius: BorderRadius.circular(50.r),
          ),
          alignment: Alignment.center,
          child: CustomText(text:
            text,
            fontsize: 16.sp,
            fontWeight: FontWeight.w400,
            color: isSelected ?AppColors.textColorFFFFFF : AppColors.primaryColorC79235,

          ),
        ),
      ),
    );
  }
}

  /// ========== Audio View ==========
  Widget _audioView() {
    final controller = Get.find<RecordStoryController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 247.w,
          height: 38.h,
          decoration: BoxDecoration(
            color:  AppColors.textColor323539,
            borderRadius: BorderRadius.circular(8.r),
          ),
          alignment: Alignment.center,
          child:  CustomText(
              text: "Add Title",
            color: AppColors.textColorFFFFFF,
            fontsize: 16.sp,
            fontWeight: FontWeight.w300,

              ),
        ),
        SizedBox(height: 19.h),
        Container(
          width: 304.w,
          height: 130.h,
          decoration: BoxDecoration(
            color:  AppColors.textColor323539,
            borderRadius: BorderRadius.circular(8.r),
          ),
          alignment: Alignment.center,
          child:
          CustomText(
              text: "Add Script",
            color: AppColors.textColorFFFFFF,
            fontsize: 16.sp,
            fontWeight: FontWeight.w300,
              ),
        ),
        SizedBox(height: 30.h),




        SizedBox(height: 30.h),

        Column(
          children: [

            Obx(() => Container(
              height: 96.h,
              width: 430.w,
              child: CustomPaint(
                painter: RealWaveformPainter(
                  controller.currentAmplitude.value,
                  isRecording: controller.isRecording.value,
                ),
                size: Size(430.w, 96.h),
              ),
            )),

            SizedBox(height: 30.h),

            /// Dynamic timer text
            Obx(() => CustomText(
              text: controller.formattedDuration,
              fontsize: 32.sp,
              color: AppColors.textColor919191,
              fontWeight: FontWeight.w400,
            )),

            SizedBox(height: 16.h),

            /// Record / Stop / Resume Button
            Obx(() => CustomButton(
              title: controller.isRecording.value
                  ? 'Stop Recording'
                  : (controller.isPaused.value ? 'Resume Recording' : 'Start Recording'),
              onpress: () {
                if (controller.isRecording.value) {
                  controller.pauseRecording();
                } else if (controller.isPaused.value) {
                  controller.resumeRecording();
                } else {
                  controller.startRecording();
                }
              },
              width: 180.w,
              height: 40,
              color: AppColors.textColor323539,
              titlecolor: AppColors.textColor919191,
              borderRadius: 8.r,
            )),

            SizedBox(height: 56.h),

            /// Action Row: Cancel, Restart, Done
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                GestureDetector(
                  onTap: () async {
                    try {
                      if (Get.isRegistered<RecordStoryController>()) {
                        await controller.cancelRecording();
                      }
                      // Get.back();
                    } catch (e) {
                      print('Error in cross button: $e');
                      // Force close even if error occurs
                      // Get.back();
                    }
                  },
                  child: Assets.icons.cross.svg(width: 40.w, height: 40.h),
                ),

                SizedBox(width: 50.w),

                /// 🔄 Restart (clear current recording and start fresh)
                GestureDetector(
                  onTap: () {
                    controller.restartRecording();
                  },
                  child: Assets.icons.resume.svg(width: 74.w, height: 74.h),
                ),

                SizedBox(width: 50.w),

                /// ✅ Done — Save the recording properly
                GestureDetector(
                  onTap: () {
                    controller.saveRecording();
                  },
                  child: Assets.icons.checkCircle.svg(width: 40.w, height: 40.h),
                ),
              ],
            ),
          ],
        )




      ],
    );
  }

  /// ========== Video View ==========
  Widget _videoView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(text:
          "Create Your Video",
            fontsize: 20.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.primaryColorC79235
        ),
        SizedBox(height: 30.h),
        CustomText(
            text:
          "Start crafting your unique story video now and share it with the world!",
          fontsize: 20.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.textColor835D1A,
          textAlign: TextAlign.center,
          maxline: 2,
        ),
        SizedBox(height: 116.h),
        Assets.icons.createvideo.svg(width: 140.w, height: 140.h),
        SizedBox(height: 70.h),
        Column(
          children: [
             CustomText(
               text: "Click on the button",
               color: AppColors.textColorFFFFFF,
               fontWeight: FontWeight.w400,
               fontsize: 20.sp,
             ),
            SizedBox(height: 14.h),
            GestureDetector(
              onTap: () {
                context.pushNamed(AppRoutes.videoCreateStoryScreen);
              },
              child:  Assets.icons.videoicon.svg(width: 68.w, height: 68.h),
            ),
          ],
        )
      ],
    );
  }



