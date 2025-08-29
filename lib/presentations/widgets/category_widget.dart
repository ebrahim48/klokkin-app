import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import 'custom_text.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 228.w,
        height: 104.h,
        decoration: BoxDecoration(
          color: AppColors.textColor323539,
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            /// Left Icon
            Center(
              child: Image.asset(
                imagePath,
                width: 48.w,
                height: 48.h,
                color: AppColors.primaryColorC79235,
              ),
            ),
            SizedBox(width: 12.w),

            /// Title + Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: title,
                    color: AppColors.textColorBDC2C6,
                    fontsize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 6.h),
                  CustomText(
                    text: subtitle,
                    color: AppColors.textColor8C8C8C,
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
