import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';

import 'custom_network_image.dart';

class CustomMainProfileImage extends StatelessWidget {
  // final String imageUrl;
  final String imagePath;

  const CustomMainProfileImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.textColor8B8B8B,
          width: 3, // border width
        ),
      ),
      child: ClipOval(
        child: CustomNetworkImage(
          imageUrl: imagePath,
          borderRadius: BorderRadius.zero,
        ),

        // Image.network(
        //   imageUrl,
        //   fit: BoxFit.cover,
        // ),


      ),
    );
  }
}
