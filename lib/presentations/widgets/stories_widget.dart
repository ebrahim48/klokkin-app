import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';

class CustomStoriesImage extends StatelessWidget {
  final String imageUrl;

  const CustomStoriesImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 242.w,
      height: 242.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.buttonColorE8A533,
          width: 3, // border width
        ),
      ),
      child: ClipOval(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
