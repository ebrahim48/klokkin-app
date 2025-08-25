import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../core/constants/app_colors.dart';

class CustomPinCodeTextField extends StatelessWidget {
  final TextEditingController? textEditingController;

  const CustomPinCodeTextField({super.key, this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 6,
      controller: textEditingController,
      cursorColor: AppColors.curserColorA48141,
      textStyle: const TextStyle(color: AppColors.textColor000000),
      autoFocus: false,
      obscureText: false,
      keyboardType: TextInputType.number,

      enableActiveFill: true,

      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(12.r),
        fieldHeight: 70.h,
        fieldWidth: 53.w,

        // Box background
        activeFillColor: AppColors.textColorF5F9FE,
        inactiveFillColor: AppColors.textColorF5F9FE,
        selectedFillColor: AppColors.textColorF5F9FE,

        activeColor: AppColors.primaryColorC79235,
        inactiveColor: AppColors.primaryColorC79235,
        selectedColor: AppColors.primaryColorC79235,
      ),

      onChanged: (value) {},
      onCompleted: (value) {
        textEditingController?.text = value;
      },
    );
  }
}
