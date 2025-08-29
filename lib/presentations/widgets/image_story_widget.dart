import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../global/custom_assets/assets.gen.dart';
import 'custom_text.dart';

class ImageStoryCard extends StatelessWidget {
  final String title;
  final String caption;
  final String imagePath;
  final String timestamp;
  final String readingTime;
  final VoidCallback? onTap;

  const ImageStoryCard({
    super.key,
    required this.title,
    required this.caption,
    required this.imagePath,
    required this.timestamp,
    required this.readingTime,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 188.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          color: AppColors.backgColor20272E,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// =============================> Image ========================>
                Container(
                  width: 188.w,
                  height: 140.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            
                SizedBox(height: 10.h),
            
                // =====================> Title and Info =====================>
                Padding(
                  padding: EdgeInsets.only(left: 1.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: title,
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textColorDCDCDC,
                      ),
                      SizedBox(height: 4.h),
                      CustomText(
                        textAlign: TextAlign.start,
                        text: caption,
                        fontsize: 12.sp,
                        fontWeight: FontWeight.w400,
                        maxline: 2,
                        color: AppColors.textColor919191,
                      ),
                      SizedBox(height: 4.h),
            
                      // Timestamp and reading time row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            textAlign: TextAlign.start,
                            text: timestamp,
                            fontsize: 12.sp,
                            fontWeight: FontWeight.w300,
                            color: AppColors.textColor919191,
                          ),
                          SizedBox(width: 8.w),
                          CustomText(
                            text: '• $readingTime',
                            fontsize: 12.sp,
                            fontWeight: FontWeight.w300,
                            color: AppColors.textColor919191,
                          ),
                          Spacer(),
                          Assets.icons.downloadSimple.svg(
                            color: AppColors.primaryColorC79235,
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 6.h),

              ],
            ),

          ),
        ),
      ),
    );
  }
}
