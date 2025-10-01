import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/presentations/widgets/custom_button.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';

class PersonalScreenUpdate extends StatefulWidget {
  const PersonalScreenUpdate({super.key});

  @override
  State<PersonalScreenUpdate> createState() => _PersonalScreenUpdateState();
}

class _PersonalScreenUpdateState extends State<PersonalScreenUpdate> {
  final Color goldColor = const Color(0xFFC79235);
  final Color darkBg = const Color(0xFF1E1E1E);
  final Color fieldBg = const Color(0xFF2A2A2A);

  final TextEditingController dobController = TextEditingController();
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: darkBg,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: 'Personal',
          fontsize: 24.sp,
          fontWeight: FontWeight.w600,
          color: goldColor,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Avatar",
                    fontsize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColorFFFFFF,
                  ),
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor: fieldBg,
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),
              Divider(color: goldColor, thickness: 1, height: 24.h),

              // Nickname
              CustomText(
                text: "Nickname",
                fontsize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textColorFFFFFF,
              ),
              SizedBox(height: 8.h),
              inputBox("Enter a name"),
              Divider(color: goldColor, thickness: 1, height: 24.h),

              // About
              CustomText(
                text: "About",
                fontsize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textColorFFFFFF,
              ),
              SizedBox(height: 8.h),
              inputBox("Enter a description", maxLines: 4),
              Divider(color: goldColor, thickness: 1, height: 24.h),

              // Date of Birth
              CustomText(
                text: "Date of Birth",
                fontsize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textColorFFFFFF,
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: dobController,
                readOnly: true,
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
                decoration: InputDecoration(
                  hintText: "Enter date of birth",
                  hintStyle:
                  TextStyle(color: Colors.grey.shade500, fontSize: 14.sp),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today,
                        color: Colors.grey.shade400),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              dialogBackgroundColor: darkBg,
                              colorScheme: ColorScheme.dark(
                                primary: goldColor,
                                onPrimary: Colors.white,
                                surface: darkBg,
                                onSurface: Colors.white,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedDate != null) {
                        setState(() {
                          dobController.text =
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                        });
                      }
                    },
                  ),
                  filled: true,
                  fillColor: fieldBg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              Divider(color: goldColor, thickness: 1, height: 24.h),

              // Gender
              CustomText(
                text: "Gender",
                fontsize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textColorFFFFFF,
              ),
              SizedBox(height: 8.h),
              DropdownButtonFormField<String>(
                dropdownColor: darkBg,
                value: selectedGender,
                decoration: InputDecoration(
                  hintText: "Write gender",
                  hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14.sp),
                  filled: true,
                  fillColor: fieldBg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide.none,
                  ),
                ),
                icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade400),
                items: ["Male", "Female", "Other"]
                    .map((gender) => DropdownMenuItem(
                  value: gender,
                  child: Text(
                    gender,
                    style: const TextStyle(color: Colors.white),
                  ),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
              ),
              SizedBox(height: 30.h),

              Center(
                child: CustomButton(
                  title: 'DONE',
                  onpress: () {},
                  width: 245.w,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable dark input field
  Widget inputBox(String hint, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      style: TextStyle(color: Colors.white, fontSize: 14.sp),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14.sp),
        filled: true,
        fillColor: fieldBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
