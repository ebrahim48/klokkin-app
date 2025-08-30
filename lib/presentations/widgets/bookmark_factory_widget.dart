import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../core/constants/app_colors.dart';
import 'custom_text.dart';

class BookmarkFactoryCard extends StatelessWidget {
  final String title;
  final String caption;
  final String imagePath;
  final VoidCallback? onTap;

  const BookmarkFactoryCard({
    super.key,
    required this.title,
    required this.caption,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          color: AppColors.textColorFFFFFF,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// =============================> Image with overlay ========================>
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 8,
                      right: 8,
                      child: Container(
                        height: 24.h,
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        decoration: BoxDecoration(
                          color:AppColors.textColorFFFFFF.withOpacity(0.1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: title,
                              color: AppColors.textColorFFFFFF,
                              fontsize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            SvgPicture.asset(
                              "assets/icons/downloadSimple.svg",
                              width: 16.w,
                              height: 16.h,
                              color: AppColors.textColorFFFFFF,
                            ),
                          ],
                        ),

                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              // Bottom caption
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(6.w),
                color: AppColors.textColorFFFFFF,
                child: CustomText(
                  text: caption,
                  fontsize: 12.sp,
                  maxline: 2,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColor000000,
                ),
              ),
              SizedBox(height: 14.h),
            ],
          ),
        ),
      ),
    );
  }
}
