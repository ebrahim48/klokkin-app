import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_colors.dart';
import 'custom_text.dart';

class CustomProfileListTile extends StatelessWidget {
  const CustomProfileListTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      shape: const Border(bottom: BorderSide(color: AppColors.borderColor4D3814)),
      leading: icon,
      title: CustomText(
        textAlign: TextAlign.start,
        text: title,
        fontsize: 16.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryColorC79235,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16.r,
        color: AppColors.primaryColorC79235,
      ),
    );
  }
}
