import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import '../../global/custom_assets/assets.gen.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onpress;
  final String title;
  final Color? color;
  final Color? titlecolor;
  final double? height;
  final double? width;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool loading;
  final bool loaderIgnore;


  CustomButton({
    super.key,
    required this.title,
    required this.onpress,
    this.color,
    this.height,
    this.width,
    this.fontSize,
    this.titlecolor,
    this.loading=false,
    this.loaderIgnore = false, this.fontWeight, this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading?(){} : onpress,
      child: Container(
        width:width?.w ?? double.infinity,
        height: height ?? 50.h,
        padding:  EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          borderRadius:BorderRadius.circular(borderRadius ?? 10.r),
          border: Border.all(color: AppColors.secondary836531),
          color: color ?? AppColors.buttonColorE8A533,
          // gradient: const LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [
          //     Color(0xFFEC6848),
          //     Color(0xFFEF9136),
          //   ],
          //   stops: [0.202, 1.0],
          // ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

           loaderIgnore ? const SizedBox() : SizedBox(width: 30.w),


            Center(
              child: CustomText(
                text: title,
                fontsize: fontSize ?? 24.h,
                color: titlecolor ?? Colors.white,
                fontWeight: fontWeight ?? FontWeight.w600,
              ),
            ),


            loaderIgnore ? const SizedBox() :  SizedBox(width: 20.w),


            loaderIgnore ? const SizedBox() :  loading  ?
                SizedBox(
                    height: 25.h,
                    width: 25.w,
                    child: Assets.lottie.buttonLoading.lottie(fit: BoxFit.cover)
                ) :  SizedBox(width: 25.w)
          ],
        ),
      ),
    );
  }
}