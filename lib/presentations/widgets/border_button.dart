import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';

class BorderButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

   const BorderButton({
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 122.w,
      height: 44.h,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFC79235),
          side: const BorderSide(color: Color(0xFFC79235), width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onPressed,
        child: CustomText(text:
          title,
            fontsize: 14.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFC79235)

        ),
      ),
    );
  }
}