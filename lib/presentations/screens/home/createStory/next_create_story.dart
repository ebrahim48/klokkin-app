import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/controllers/home_controller.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import 'package:klokkin_app/presentations/widgets/custom_loader.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';

import '../../../../core/config/app_routes/app_routes.dart';


class NextCreateStoryScreen extends StatefulWidget {
  NextCreateStoryScreen({super.key});

  @override
  State<NextCreateStoryScreen> createState() => _NextCreateStoryScreenState();
}

class _NextCreateStoryScreenState extends State<NextCreateStoryScreen> {

  RxSet<int> expandedIndices = <int>{}.obs;
  HomeController homeController = Get.put(HomeController());
  RxSet<String> selectedTags = <String>{}.obs;
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.getAllTags();
    });
  }

  @override
  Widget build(BuildContext context) {
    Map routeData = GoRouterState.of(context).extra as Map;
    return Scaffold(
      appBar: CustomAppBar(title: "${routeData["title"]}"),
      body: SingleChildScrollView(
        padding:  EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
             CustomText(
                 text: "Title",
                 fontsize: 20.sp,
               fontWeight: FontWeight.w500,
               color: AppColors.textColorFFFFFF,
             ),
             SizedBox(height: 12.h),
             TextField(
              controller: titleCtrl,
              decoration: _inputDecoration("Enter a name"),
            ),
             SizedBox(height: 20.h),
            /// Description
            CustomText(
              text: "Description",
              fontsize: 20.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textColorFFFFFF,
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: scriptCtrl,
              maxLines: 5,
              decoration: _inputDecoration("Enter description"),
            ),
             SizedBox(height: 20.h),

            /// ======================================== Select Tag ===================================>
            CustomText(
              text: "Select Tag",
              fontsize: 20.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textColorFFFFFF,
            ),
            SizedBox(height: 10.h),

            Obx(() {
              if (homeController.getAllTagsLoading.value) {
                return const Center(child: CustomLoader());
              }

              if (homeController.allTags.isEmpty) {
                return CustomText(
                  text: "No tags available",
                  color: AppColors.textColorC2C2C2,
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: homeController.allTags.length,
                itemBuilder: (context, index) {
                  final tagGroup = homeController.allTags[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: _buildRowItem(
                          tagGroup.name ?? "",
                          index: index,
                        ),
                      ),
                      Obx(() {
                        bool isExpanded = expandedIndices.contains(index);
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: isExpanded ?
                          (tagGroup.tag?.isNotEmpty ?? false ? 56.h : 0) : 0,
                          child: isExpanded && (tagGroup.tag?.isNotEmpty ?? false)
                              ? Container(
                            width: 340.w,
                            margin: EdgeInsets.symmetric(vertical: 8.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF323539),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h
                              ),
                              children: [
                                ...tagGroup.tag!.map((t) => _chip("#$t")).toList(),
                                _chip("Add New", isAddNew: true, onAddNew: () {
                                  _showAddTagDialog(index);
                                }),
                              ],
                            ),
                          )
                              : const SizedBox.shrink(),
                        );
                      }),
                    ],
                  );
                },
              );
            }),

            SizedBox(height: 27.h),
            /// ===============================> Next Button ==================================
            Align(
               alignment: Alignment.center,
              child:
                  OutlinedButton(
                    onPressed: () {
                      context.pushNamed(
                        AppRoutes.uploadCreateStoryScreen,
                        extra: {
                          "pageTitle": "Create a story",
                          "title": titleCtrl.text.trim(),
                          "script": scriptCtrl.text.trim(),
                          "tags": selectedTags.toList(),

                        },
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.buttonColorE8A533,
                      side: BorderSide(
                        color: AppColors.buttonColorE8A533,
                        width: 2.w,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 46.w, vertical: 12.h),
                    ),
                    child: CustomText(
                      text: "Next",
                      color: AppColors.textColorFFFFFF,
                      fontsize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

              ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,

      hintStyle:  const TextStyle(color: AppColors.textColor8C8C8C),
      filled: true,
      fillColor: AppColors.textColorF5F9FE,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide.none,
      ),
    );
  }
  Widget _buildRowItem(String text, {required int index}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
      decoration: const BoxDecoration(
        color:AppColors.textColor323539,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: text,
            color: AppColors.textColorC2C2C2,
          ),
          GestureDetector(
            onTap: () {
              if (expandedIndices.contains(index)) {
                expandedIndices.remove(index);
              } else {
                expandedIndices.add(index);
              }
            },
            child: Obx(() {
              bool isExpanded = expandedIndices.contains(index);
              return AnimatedRotation(
                turns: isExpanded ? 0.50 : 0,
                duration: const Duration(milliseconds: 200),
                child: SvgPicture.asset(
                  "assets/icons/caretRight.svg",
                  width: 20.w,
                  height: 20.h,
                  color: AppColors.textColorC2C2C2,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }


  Widget _chip(String label, {bool isAddNew = false, VoidCallback? onAddNew}) {
    return Obx(() {
      bool isSelected = selectedTags.contains(label);

      return GestureDetector(
        onTap: () {
          if (isAddNew) {
            if (onAddNew != null) onAddNew();
          } else {
            if (isSelected) {
              selectedTags.remove(label);
            } else {
              selectedTags.add(label);
              print("👉 Selected: $label");
            }
          }
        },
        child: Container(
          margin: EdgeInsets.only(right: 8.w),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isAddNew
                  ? AppColors.buttonColorE8A533
                  : (isSelected
                  ? AppColors.buttonColorE8A533
                  : AppColors.textColorFFFFFF),
            ),
            color: isAddNew
                ? AppColors.buttonColorE8A533.withOpacity(0.1)
                : (isSelected
                ? AppColors.buttonColorE8A533.withOpacity(0.2)
                : Colors.transparent),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isAddNew)
                Icon(
                  Icons.add,
                  size: 14.r,
                  color: AppColors.buttonColorE8A533,
                ),
              if (isAddNew) SizedBox(width: 4.w),
              CustomText(
                text: label,
                color: isAddNew
                    ? AppColors.buttonColorE8A533
                    : (isSelected
                    ? AppColors.buttonColorE8A533
                    : AppColors.textColorFFFFFF),
                fontsize: 12.sp,
                fontWeight: FontWeight.w300,
              ),
            ],
          ),
        ),
      );
    });
  }


  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController scriptCtrl = TextEditingController();


  void _showAddTagDialog(int groupIndex) {
    final TextEditingController newTagCtrl = TextEditingController();
    final tagGroup = homeController.allTags[groupIndex];
    final tagId = tagGroup.id!;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.backgColor20272E,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          title: CustomText(
            text: "Add New Tag",
            color: AppColors.textColorFFFFFF,
            fontsize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
          content: TextField(
            controller: newTagCtrl,
            decoration: _inputDecoration("Enter new tag"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: CustomText(
                text: "Back",
                color: AppColors.textColorC2C2C2,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonColorE8A533,
              ),
              onPressed: () async {
                final newTag = newTagCtrl.text.trim();
                if (newTag.isEmpty) return;


                await homeController.updateTag(
                  tagId,
                  [...?tagGroup.tag, newTag],
                );

                tagGroup.tag?.add(newTag);
                homeController.allTags.refresh();
                Navigator.pop(ctx);
              },
              child: CustomText(
                text: "Add",
                color: AppColors.textColorFFFFFF,
              ),
            ),
          ],
        );
      },
    );
  }

}








