import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import '../../../controllers/audio_book_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../global/custom_assets/assets.gen.dart';
import '../../widgets/custom_loader.dart';
import '../../widgets/image_story_list_widget.dart';
import 'package:intl/intl.dart';



class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AudioBookController controller = Get.put(AudioBookController());

  @override
  void initState() {
    super.initState();
    controller.getLibraryStoryData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Obx((){
          if (controller.getLibraryStoryLoading.value) {
            return const Center(child: CustomLoader());
          }

          if (controller.libraryStoryData.isEmpty) {
            return Center(
              child: CustomText(
                text: "Data Unavailable",
                textAlign: TextAlign.center,
                color: AppColors.textColorC2C2C2,
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      /// =====================================> Downloading =====================================>
                      CustomText(
                        text: 'Downloading',
                        color: AppColors.primaryColorC79235,
                        fontsize: 24.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      const Spacer(),

                      SizedBox(
                        width: 35.w,
                        child: Assets.icons.dot.svg(width: 22.w, height: 22.h),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 14.h),
                Padding(
                  padding:  EdgeInsets.only(left: 20.w,right: 15.h),
                  child: Divider(
                    color: AppColors.secondary836531,
                    height: 0.4.h,
                    thickness: 0.6,
                  ),
                ),


                SizedBox(
                  height: 400.h,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: controller.libraryStoryData.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final downloadData = controller.libraryStoryData[index];
                      final createdAt = downloadData.createdAt;
                      String formattedDate = 'N/A';

                      if (createdAt != null && createdAt is String) {
                        final parsed = DateTime.tryParse(createdAt as String);
                        if (parsed != null) {
                          formattedDate = DateFormat("MMM d, yyyy • h:mm a").format(parsed);
                        }
                      }
                      return ImageListCard(
                        title: downloadData.caption ?? 'N/A',
                        subtitle: downloadData.description ?? 'N/A',
                        meta: formattedDate,
                        hashtags: (downloadData.tags is List)
                            ? (downloadData.tags as List).join(", ")
                            : (downloadData.tags?.toString() ?? 'N/A'),
                        imagePath: downloadData.mediaUrl != null && downloadData.mediaUrl!.isNotEmpty
                            ? downloadData.mediaUrl!.first
                            : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                        onTap: () {
                          // context.pushNamed(AppRoutes.storyAudioScreen);
                        },
                      );
                    },
                  ),
                ),


                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      /// =====================================> My Downloads =====================================>
                      CustomText(
                        text: 'My Downloads',
                        color: AppColors.primaryColorC79235,
                        fontsize: 24.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      const Spacer(),

                      SizedBox(
                        width: 35.w,
                        child: Assets.icons.dot.svg(width: 22.w, height: 22.h),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding:  EdgeInsets.only(left: 20.w,right: 15.h),
                  child: Divider(
                    color: AppColors.secondary836531,
                    height: 0.4.h,
                    thickness: 0.6,
                  ),
                ),

                SizedBox(height: 11.h),

                SizedBox(
                  height: 400.h,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: controller.libraryStoryData.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final myDownloadData = controller.libraryStoryData[index];
                      return ImageListCard(
                        title: myDownloadData.caption ?? 'N/A',
                        subtitle: myDownloadData.description ?? 'N/A',
                        meta: myDownloadData.duration ?? 'N/A',
                        hashtags: (myDownloadData.tags is List)
                            ? (myDownloadData.tags as List).join(", ")
                            : (myDownloadData.tags?.toString() ?? 'N/A'),
                        imagePath: myDownloadData.mediaUrl != null && myDownloadData.mediaUrl!.isNotEmpty
                            ? myDownloadData.mediaUrl!.first
                            : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                        onTap: () {
                          // context.pushNamed(AppRoutes.storyAudioScreen);
                        },
                      );
                    },
                  ),
                ),











                SizedBox(height: 10.h),
              ],
            ),
          );
        }

        ),
      ),
    );
  }
}



