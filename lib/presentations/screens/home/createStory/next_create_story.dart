import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/controllers/home_controller.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';

import '../../../../core/config/app_routes/app_routes.dart';


class NextCreateStoryScreen extends StatefulWidget {
  NextCreateStoryScreen({super.key});

  @override
  State<NextCreateStoryScreen> createState() => _NextCreateStoryScreenState();
}

class _NextCreateStoryScreenState extends State<NextCreateStoryScreen> {


  HomeController homeController = Get.put(HomeController());

  void initState() {
    super.initState();
    homeController.getAllTags();
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
            /// Write a script
            CustomText(
              text: "Write a script",
              fontsize: 20.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textColorFFFFFF,
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: scriptCtrl,
              maxLines: 5,
              decoration: _inputDecoration("Enter text"),
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
             Container(
            width: 370.w,
            decoration: BoxDecoration(
              color: const Color(0xFF323539),
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRowItem("Name"),
                _buildRowItem("Company", isChipsRow: true),
                if (_showChips)
                  Container(
                    width: 340.w,
                    height: 38.h,
                    margin: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF323539),
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x401C1818),
                          offset: const Offset(0, 4),
                          blurRadius: 4.r,
                        ),
                        BoxShadow(
                          color: const Color(0x401C1818),
                          offset: const Offset(0, -4),
                          blurRadius: 6.r,
                        ),
                      ],
                    ),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      children: [
                        _chip("#innovation"),
                        _chip("#innovation"),
                        _chip("#innovation"),
                        _chip("Add New", isAddNew: true),
                      ],
                    ),
                  ),
                _buildRowItem("Industry"),
                _buildRowItem("Job Role"),
                _buildRowItem("Year"),
              ],
            ),
          ),

            SizedBox(height: 27.h),
            /// ===============================> Next Button ==================================
            Align(
               alignment: Alignment.center,
              child: OutlinedButton(
                onPressed: () {
                  context.pushNamed(
                      AppRoutes.uploadCreateStoryScreen,
                      extra: {"title" : "Create a story"
                      });

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
                child: CustomText(text:
                "Next",
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
      fillColor: AppColors.textColor323539,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide.none,
      ),
    );
  }


  Widget _buildRowItem(String text, {bool isChipsRow = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: text,
            color: AppColors.textColorC2C2C2,

          ),
      GestureDetector(
        onTap: () {
          if (isChipsRow) {
            setState(() {
              _showChips = !_showChips;
            });
          }
        },
        child: AnimatedRotation(
          turns: isChipsRow
              ? (_showChips ? 0.50 : 0)
              : 0,
          duration: const Duration(milliseconds: 200),
          child: SvgPicture.asset(
            "assets/icons/caretRight.svg",
            width: 14.w,
            height: 14.h,
            color: AppColors.textColorC2C2C2,
          ),
        ),
      )
      ],
      ),
    );
  }



  Widget _chip(String label, {bool isAddNew = false}) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.textColorFFFFFF),
      ),
      child: CustomText(text:
        label,
        color: AppColors.textColorFFFFFF,
        fontsize: 12.sp,
        fontWeight: FontWeight.w300,

      ),
    );
  }



  bool _showChips = false;

  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController scriptCtrl = TextEditingController();


}







