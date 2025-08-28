import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import '../../../../global/custom_assets/assets.gen.dart';

class VideoCreateStoryScreen extends StatelessWidget {
  const VideoCreateStoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Assets.icons.settings.svg(width: 24.w, height: 24.h),
          ),
        ],
      ),
      body: Column(
        children: [
          /// ================= Fullscreen Image =================
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    "assets/images/videocreate.png",
                    fit: BoxFit.cover,
                  ),
                ),

                /// ================= Overlay with Info =================
                Positioned(
                  bottom: 40.h,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 16.h),

                      /// Control Buttons
                      _audioView(),
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

/// ========== Audio View ==========
Widget _audioView() {
    return Column( crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 30.h),
        CustomText(
            text: "00:08:10", fontsize: 32.sp,
            color: AppColors.textColor000000,
            fontWeight: FontWeight.w400), SizedBox(height: 8.h),
        Row( mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.cross.svg( color: AppColors.textColorFFFFFF,
              width: 40.w, height: 40.h), SizedBox(width: 50.w),
            Assets.icons.videoicon.svg(width: 74.w, height: 74.h),
            SizedBox(width: 50.w),
            Assets.icons.checkCircle.svg( color: AppColors.textColorFFFFFF,
                width: 40.w, height: 40.h),
          ],
        ),
      ],
    );
  }
}
