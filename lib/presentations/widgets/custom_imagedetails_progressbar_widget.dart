import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import 'package:intl/intl.dart';
import '../../controllers/audio_book_controller.dart';
import '../../controllers/audio_controller.dart';
import '../../core/constants/app_colors.dart';

class CustomImageDetailsProgressBar extends StatefulWidget {
  CustomImageDetailsProgressBar({super.key});

  @override
  State<CustomImageDetailsProgressBar> createState() => _CustomImageDetailsProgressBarState();
}

class _CustomImageDetailsProgressBarState extends State<CustomImageDetailsProgressBar> {

  final AudioBookController controllers = Get.put(AudioBookController());

  void initState() {
    super.initState();
    controllers.getLibraryStoryData();
  }
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AudioController());


      return Obx(() {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 28.h),
            CustomText(
              textAlign: TextAlign.start,
              text: controllers.libraryStoryData.first.caption ?? 'N/A',
              color: AppColors.textColorFFFFFF,
              fontsize: 24.sp,
              fontWeight: FontWeight.w500,
              maxline: 2,
            ),
            SizedBox(height: 17.h),
            CustomText(
              textAlign: TextAlign.start,
              text: controllers.libraryStoryData.first.description ?? 'N/A',
              color: AppColors.textColorFFFFFF,
              fontsize: 16.sp,
              fontWeight: FontWeight.w400,
              maxline: 10,
            ),
            SizedBox(height: 17.h),
            CustomText(
              textAlign: TextAlign.start,
              text: 'Post: ${DateFormat("dd MMM yyyy").format(DateTime.parse('${controllers.libraryStoryData.value.first.createdAt}'))}',
              color: AppColors.textColorFFFFFF,
              fontsize: 14.sp,
              fontWeight: FontWeight.w400,
            ),

            SizedBox(height: 17.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8.w,
                    children: controller.hashtags.map((tag) {
                      return GestureDetector(
                        onTap: () {
                          print("$tag tapped");
                        },
                        child: CustomText(text:
                        tag,
                          color: AppColors.textColor2165DF, fontsize: 14.sp, fontWeight: FontWeight.w400,
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Download Icon
                GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset(
                    "assets/icons/downloadSimple.svg",
                    width: 24.w,
                    height: 24.h,
                    color: AppColors.primaryColorC79235,
                  ),
                ),
              ],
            ),
            SizedBox(height: 100.h),

          ],
        );
      }
      );
    }
}
