import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:klokkin_app/presentations/widgets/custom_button.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';

import '../../../controllers/home_controller.dart';


class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final Color goldColor = const Color(0xFFC79235);
  final Color darkBg = const Color(0xFF1E1E1E);
  final Color fieldBg = const Color(0xFFF5F5F5);

  final TextEditingController feedbackController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: darkBg,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: 'Feedback',
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
              CustomText(
                text: "Please write your feedback or comments below :",
                color: goldColor,
                fontsize: 14.sp,
              ),
              SizedBox(height: 12.h),

              /// Feedback box
              Container(
                height: 150.h,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: fieldBg,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: TextField(
                  controller: feedbackController,
                  maxLines: null,
                  expands: true,
                  style: TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Tap to enter...",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 16.h),


              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (context) => Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.camera_alt, color: goldColor, size: 40),
                                onPressed: () {
                                  Navigator.pop(context);
                                  _pickImage(ImageSource.camera);
                                },
                              ),
                              Text("Camera", style: TextStyle(color: goldColor)),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.photo, color: goldColor, size: 40),
                                onPressed: () {
                                  Navigator.pop(context);
                                  _pickImage(ImageSource.gallery);
                                },
                              ),
                              Text("Gallery", style: TextStyle(color: goldColor)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            color: _selectedImage == null ? Colors.white : null,
                            borderRadius: BorderRadius.circular(12.r),
                            border: _selectedImage != null
                                ? Border.all(color: goldColor, width: 2)
                                : null,
                            image: _selectedImage != null
                                ? DecorationImage(
                              image: FileImage(_selectedImage!),
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),
                          child: _selectedImage == null
                              ? Icon(Icons.add, color: goldColor, size: 30)
                              : null,
                        ),

                        if (_selectedImage != null)
                          Positioned(
                            top: -5,
                            right: -5,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedImage = null;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      text: _selectedImage == null ? "Add\nPhotos" : "Change\nPhoto",
                      color: goldColor,
                      fontsize: 10.sp,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),



              SizedBox(height: 250.h),
              Obx(
                    () => Center(
                  child: CustomButton(
                    loading: homeController.feedbackLoading.value,
                    title: 'Send',
                    onpress: () {
                      homeController.feedback(
                        file: _selectedImage,
                        comment: feedbackController.text.trim(),
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

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }


}

