import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';

import 'custom_network_image.dart';

class CustomProfileImageDetailsImage extends StatelessWidget {
  final String imagePath;

  const CustomProfileImageDetailsImage({super.key,  required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.w,
      height: 48.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.buttonColorE8A533,
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



