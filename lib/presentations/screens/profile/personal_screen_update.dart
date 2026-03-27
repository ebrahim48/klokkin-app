import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import '../../../controllers/home_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_network_image.dart';

class PersonalScreenUpdate extends StatefulWidget {
  const PersonalScreenUpdate({super.key});

  @override
  State<PersonalScreenUpdate> createState() => _PersonalScreenUpdateState();
}

class _PersonalScreenUpdateState extends State<PersonalScreenUpdate> {
  final Color goldColor = const Color(0xFFC79235);
  final Color darkBg = const Color(0xFF1E1E1E);
  final Color fieldBg = const Color(0xFF2A2A2A);

  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  String? selectedGender;
  File? selectedImage;
  String? profileImagePath;
  DateTime? _selectedDate;
  bool _initialized = false;

  HomeController homeController = Get.put(HomeController());

  /// Formats DateTime for display: "14 Mar 1998"
  String _formatForDisplay(DateTime date) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  /// Formats DateTime for API: "1998-03-14"
  String _formatForApi(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    final routerData = (GoRouterState.of(context).extra as Map?) ?? {};

    nicknameController.text = routerData["nickname"] ?? "";
    aboutController.text = routerData["aboutself"] ?? "";
    profileImagePath = routerData["avatar"] as String?;

    final genderValue = routerData["gender"] as String?;
    selectedGender = (genderValue == 'Male' || genderValue == 'Female' || genderValue == 'Other')
        ? genderValue
        : null;

    final isoDate = routerData["dateofBirth"] as String? ?? "";
    if (isoDate.isNotEmpty) {
      try {
        _selectedDate = DateTime.parse(isoDate);
        dobController.text = _formatForDisplay(_selectedDate!);
      } catch (_) {
        dobController.text = isoDate;
      }
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: darkBg,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: 'Personal Update',
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
                  GestureDetector(
                    onTap: () {
                      showImagePickerOption(context);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 50.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primaryColorC79235,
                              width: 3,
                            ),
                          ),
                          child: selectedImage != null
                              ? ClipOval(
                              child: Image.file(selectedImage!,
                                  fit: BoxFit.cover))
                              : CustomNetworkImage(
                            boxShape: BoxShape.circle,
                            imageUrl: profileImagePath ?? "",
                            height: 100.h,
                            width: 100.w,
                          ),
                        ),
                        Positioned(
                          top: 67.h,
                          left: 42.w,
                          child: Container(
                            width: 26.58.w,
                            height: 26.58.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: AppColors.textColorFFFFFF,
                              size: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
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
              inputBox("Enter a name", controller: nicknameController),
              Divider(color: goldColor, thickness: 1, height: 24.h),

              // About
              CustomText(
                text: "About",
                fontsize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textColorFFFFFF,
              ),
              SizedBox(height: 8.h),
              inputBox("Enter a description",
                  controller: aboutController, maxLines: 4),
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
                          _selectedDate = pickedDate;
                          dobController.text = _formatForDisplay(pickedDate);
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
                  hintStyle:
                  TextStyle(color: Colors.grey.shade500, fontSize: 14.sp),
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

              Obx(
                    () => Center(
                  child: CustomButton(
                    loading: homeController.updateProfileLoading.value,
                    title: 'Update Profile',
                    onpress: () {
                      homeController.updateProfile(
                        file: selectedImage,
                        aboutself: aboutController.text,
                        dateofBirth: _selectedDate != null
                            ? _formatForApi(_selectedDate!)
                            : null,
                        gender: selectedGender,
                        nickname: nicknameController.text,
                        context: context,
                      );
                    },
                    width: 245.w,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget inputBox(String hint,
      {TextEditingController? controller, int maxLines = 1}) {
    return TextField(
      controller: controller,
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

  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.white.withOpacity(.5),
        elevation: 3,
        context: context,
        builder: (builder) {
          return Container(
            decoration: BoxDecoration(
              border: const Border(
                  top: BorderSide(color: AppColors.primaryColorC79235, width: 0.25)),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 9.2,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _pickImageFromGallery();
                        },
                        child: SizedBox(
                          child: Column(
                            children: [
                              Icon(
                                Icons.image,
                                size: 50.w,
                              ),
                              CustomText(text: 'Gallery')
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _pickImageFromCamera();
                        },
                        child: SizedBox(
                          child: Column(
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 50.w,
                              ),
                              CustomText(text: 'Camera')
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Navigator.pop(context);
      selectedImage = File(pickedFile.path);
      setState(() {});
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      Navigator.pop(context);
      selectedImage = File(pickedFile.path);
      setState(() {});
    }
  }
}
