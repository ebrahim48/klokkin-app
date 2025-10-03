import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';

import 'custom_network_image.dart';



class CustomProfileAvatarImage extends StatelessWidget {
  final String imagePath;

  const CustomProfileAvatarImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    const fallbackUrl =
        "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png";

    final validUrl = (imagePath.isNotEmpty && Uri.tryParse(imagePath)?.hasAbsolutePath == true)
        ? imagePath
        : fallbackUrl;

    return Container(
      width: 32.w,
      height: 32.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.textColor8B8B8B,
          width: 3,
        ),
      ),
      child: ClipOval(
        child: CustomNetworkImage(
          imageUrl: validUrl,
          borderRadius: BorderRadius.zero,
        ),
      ),
    );
  }
}




// class CustomProfileAvatarImage extends StatelessWidget {
//   // final String imageUrl;
//   final String imagePath;
//
//   const CustomProfileAvatarImage({super.key, required this.imagePath});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 32.w,
//       height: 32.h,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: AppColors.textColor8B8B8B,
//           width: 3, // border width
//         ),
//       ),
//       child: ClipOval(
//         child: CustomNetworkImage(
//           imageUrl: imagePath,
//           borderRadius: BorderRadius.zero,
//         ),
//
//         // Image.network(
//         //   imageUrl,
//         //   fit: BoxFit.cover,
//         // ),
//
//
//       ),
//     );
//   }
// }
