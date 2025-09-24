import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import '../../../../controllers/playback_controller.dart';
import '../../../../controllers/video_create_controller.dart';
import '../../../../global/custom_assets/assets.gen.dart';

class VideoCreateStoryScreen extends StatefulWidget {
  const VideoCreateStoryScreen({super.key});

  @override
  State<VideoCreateStoryScreen> createState() => _VideoCreateStoryScreenState();
}

class _VideoCreateStoryScreenState extends State<VideoCreateStoryScreen> {
  // CameraController _cameracontroller;
  final videoController = Get.put(VideoCreateController());

  // @override
  // void initState() {
  //   _cameraController = CameraController(
  //     backCamera,
  //     ResolutionPreset.high,
  //     enableAudio: true,
  //   );
  //   //
  //   // await _cameraController!.initialize();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        actions: [
          SizedBox(width: 15.w),

        ],
      ),
      body: Column(
        children: [

          /// ================= Camera Preview =================
          Expanded(
            child: Stack(
              children: [
                // Camera Preview or Placeholder
                /*    Positioned.fill(
                  child: Obx(() => videoController.isInitialized.value
                      ? videoController.getCameraPreview() ?? Container(
                    color: Colors.black,
                    child: Center(
                      child: CustomText(
                        text: "📹\nCamera Loading...",
                        fontsize: 20.sp,
                        color: Colors.white,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                      : Container(
                    color: Colors.black,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 20.h),
                          CustomText(
                            text: "Initializing Camera...",
                            fontsize: 16.sp,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  )),
                ),*/
                // CameraPreview(_cameraController!),


                // Camera Switch Button (Top Right)
                Positioned(
                  top: 20.h,
                  right: 20.w,
                  child: GestureDetector(
                    onTap: () {
                      videoController.switchCamera();
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: Icon(
                        Icons.flip_camera_ios,
                        color: Colors.white,
                        size: 24.w,
                      ),
                    ),
                  ),
                ),

                // Recording Indicator (Top Left)
                Obx(() =>
                videoController.isRecording.value
                    ? Positioned(
                  top: 20.h,
                  left: 20.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8.w,
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        CustomText(
                          text: "REC",
                          fontsize: 12.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                )
                    : SizedBox.shrink()),

                /// ================= Bottom Controls =================
                Positioned(
                  bottom: 40.h,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      /// Timer
                      Obx(() =>
                          CustomText(
                            text: videoController.formattedDuration,
                            fontsize: 32.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          )),

                      SizedBox(height: 30.h),

                      /// Control Buttons
                      /*  _videoControlView(videoController),*/
                      SizedBox(height: 50.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}