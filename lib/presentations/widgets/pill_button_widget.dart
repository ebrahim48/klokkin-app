import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_colors.dart';
import 'custom_text.dart';

class PillButton extends StatelessWidget {
  final String label;
  final double width;
  final double height;
  final VoidCallback onTap;

  const PillButton({
    required this.label,
    required this.width,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.r),
          side: BorderSide(
            color: AppColors.textColor323539,
            width: 2.w,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(50.r),
          onTap: onTap,
          child: Center(
            child: CustomText(
              text: label,
              color: AppColors.textColorFFFFFF,
              fontsize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}