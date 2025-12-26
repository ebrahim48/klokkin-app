import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';

import '../../../controllers/audio_book_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/custom_app_bar.dart';


class StoryEditScreen extends StatefulWidget {
  const StoryEditScreen({super.key});

  @override
  State<StoryEditScreen> createState() => _StoryEditScreenState();
}

class _StoryEditScreenState extends State<StoryEditScreen> {
  final AudioBookController controller = Get.put(AudioBookController());

  TextEditingController? titleController;
  TextEditingController? descriptionController;

  String? storyId;
  List<String>? tags;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final routeData = GoRouterState.of(context).extra as Map;

      storyId = routeData['storyId'];
      tags = routeData['tags'] as List<String>?;

      titleController = TextEditingController(text: routeData['caption'] ?? '');
      descriptionController = TextEditingController(text: routeData['description'] ?? '');

      setState(() {});
    });
  }

  @override
  void dispose() {
    titleController?.dispose();
    descriptionController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgColor20272E,
      appBar: CustomAppBar(
        title: "Edit",
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: CustomText(
              text: "Cancel",
              color: AppColors.textColorFFFFFF,
              fontsize: 16.sp,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              CustomText(
                text: "Title",
                color: AppColors.textColorFFFFFF,
                fontsize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 8.h),
              Container(
                width: 370.w,
                height: 42.h,
                decoration: BoxDecoration(
                  color: AppColors.textColor323539,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: TextField(
                  controller: titleController,
                  style: TextStyle(
                    color: AppColors.textColorFFFFFF,
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter title",
                    hintStyle: TextStyle(
                      color: AppColors.textColor6B6B6B,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              /// Description
              CustomText(
                text: "Write a description",
                color: AppColors.textColorFFFFFF,
                fontsize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 8.h),
              Container(
                width: 370.w,
                height: 255.h,
                decoration: BoxDecoration(
                  color: AppColors.textColor323539,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.all(12.w),
                child: TextField(
                  controller: descriptionController,
                  maxLines: 10,
                  style: TextStyle(
                    color: AppColors.textColorFFFFFF,
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Write your description here...",
                    hintStyle: TextStyle(
                      color: AppColors.textColor6B6B6B,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              /// Tags (Optional - if you want to show them)
              if (tags != null && tags!.isNotEmpty) ...[
                CustomText(
                  text: "Tags",
                  color: AppColors.textColorFFFFFF,
                  fontsize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 8.h),
                CustomText(
                  text: tags!.join(", "),
                  color: AppColors.textColor2165DF,
                  fontsize: 14.sp,
                ),
                SizedBox(height: 24.h),
              ],


              /// Update Button
              Center(
                child: Obx(() => GestureDetector(
                  onTap: controller.updateStoryLoading.value
                      ? null
                      : () async {
                    if (storyId != null) {
                      await controller.updateStory(
                        storyId!,
                        titleController?.text ?? '',
                        descriptionController?.text ?? '',
                      );
                      await controller.getLibraryStoryData();
                      if (mounted) {
                        context.pop();
                      }
                    }
                  },
                  child: Container(
                    width: 102.w,
                    height: 38.h,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColorC79235,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Center(
                      child: controller.updateStoryLoading.value
                          ? SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : CustomText(
                        text: "Update",
                        color: Colors.white,
                        fontsize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}