import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../global/custom_assets/assets.gen.dart';
import 'custom_text.dart';

class BookmarkInnovationCard extends StatelessWidget {
  final String title;
  final String caption;
  final String imagePath;
  final VoidCallback? onTap;

  const BookmarkInnovationCard({
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
        width: 104.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          color: AppColors.backgColor20272E,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// =============================> Image with Bookmark Icon ========================>
              Stack(
                children: [
                  Container(
                    width: 104.w,
                    height: 63.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                      image: DecorationImage(
                        image: AssetImage(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  /// Bookmark Icon Top Right
                  Positioned(
                    top: 8.h,
                    right: 6.w,
                    child: Assets.icons.bookmarkSimple.svg(
                      width: 20.w,
                      height: 20.h,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFC79235),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8.h),

              /// =====================> Title and Info =====================>
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      textAlign: TextAlign.start,
                      text: title,
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColorDCDCDC,
                    ),
                    SizedBox(height: 5.h),
                    CustomText(
                      textAlign: TextAlign.start,
                      text: caption,
                      fontsize: 12.sp,
                      fontWeight: FontWeight.w300,
                      maxline: 2,
                      color: AppColors.textColor919191,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
