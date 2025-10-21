import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/constants/app_colors.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import '../../../controllers/audio_book_controller.dart';
import '../../../controllers/home_controller.dart';
import '../../../global/custom_assets/assets.gen.dart';
import '../../widgets/custom_image_details_widget.dart';
import '../../widgets/custom_imagedetails_progressbar_widget.dart';
import '../../widgets/custom_network_image.dart';



class StoryImageDetailsScreen extends StatefulWidget {
  StoryImageDetailsScreen({super.key});

  @override
  State<StoryImageDetailsScreen> createState() => _StoryImageDetailsScreenState();
}

class _StoryImageDetailsScreenState extends State<StoryImageDetailsScreen> {


  HomeController homeController = Get.put(HomeController());
  final AudioBookController controller = Get.put(AudioBookController());

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.getProfile();
    });

  }

  @override
  Widget build(BuildContext context) {
    Map routeData = GoRouterState.of(context).extra as Map;
    final String storyId = routeData["id"] ?? "";
    final String caption = routeData["caption"] ?? "";
    final String description = routeData["description"] ?? "";
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 28.h),

              /// ============================================ profile ====================================>

              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15.w),
                    child:   CustomProfileImageDetailsImage(
                      imagePath: homeController.profile.value.profile?.avatar != null &&
                          homeController.profile.value.profile!.avatar!.isNotEmpty
                          ? homeController.profile.value.profile!.avatar!
                          : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                    ),

                  ),
                  SizedBox(width: 11.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomText(
                              text: homeController.profile.value.fname ?? 'N/A',
                              color: AppColors.textColorFFFFFF,fontsize: 20.sp,fontWeight: FontWeight.w500),
                         SizedBox(width: 130.w),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  TextEditingController captionController =
                                  TextEditingController(text: caption);
                                  TextEditingController descriptionController =
                                  TextEditingController(text: description);

                                  return AlertDialog(
                                    backgroundColor: AppColors.backgColor20272E,
                                    title: CustomText(
                                      text: "Edit Story",
                                      color: AppColors.textColorFFFFFF,
                                      fontsize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: captionController,
                                          style: const TextStyle(color: Colors.white),
                                          decoration: const InputDecoration(
                                            hintText: "Enter caption",
                                            hintStyle: TextStyle(color: Colors.grey),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: AppColors.primaryColorC79235),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: AppColors.primaryColorC79235),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 15.h),
                                        TextField(
                                          controller: descriptionController,
                                          style: const TextStyle(color: Colors.white),
                                          maxLines: 3,
                                          decoration: const InputDecoration(
                                            hintText: "Enter description",
                                            hintStyle: TextStyle(color: Colors.grey),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: AppColors.primaryColorC79235),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: AppColors.primaryColorC79235),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: CustomText(
                                          text: "Cancel",
                                          color: Colors.grey,
                                          fontsize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          // Update the values
                                          await controller.updateStory(
                                            storyId,
                                            captionController.text,
                                            descriptionController.text,
                                          );
                                          Navigator.of(context).pop();
                                          // Optionally reload data
                                          controller.getLibraryStoryData();

                                          // Show feedback
                                          Get.snackbar(
                                            "Updated",
                                            "Story updated successfully",
                                            backgroundColor: Colors.green,
                                            colorText: Colors.white,
                                          );
                                        },
                                        child: CustomText(
                                          text: "Save",
                                          color: AppColors.primaryColorC79235,
                                          fontsize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Assets.icons.editImage.svg(),
                          ),

                          SizedBox(width: 10.w),
                          GestureDetector(
                            onTap: () {
                              
                            },
                              child: Assets.icons.deleteimage.svg())
                        ],
                      ),
                      CustomText(
                          text: 'Bangladesh',
                          color: AppColors.textColorC2C2C2,
                          fontsize: 16.sp,
                          fontWeight: FontWeight.w500),

                    ],
                  )


                ],
              ),
              /// ============================================ Image ====================================>
              SizedBox(height: 40.h),
              Stack(
                children: [
                  CustomNetworkImage(
                    imageUrl: "${routeData["imagePath"]}",
                    boxShape: BoxShape.rectangle,
                    height: 200.h,
                    width: double.infinity,
                  ),
                  // const Positioned(
                  //   bottom: 10,
                  //   top: 12,
                  //   right: 80,
                  //   child: Icon(Icons.play_circle_fill, size: 40, color: Colors.white),
                  // ),
                ],
              ),

              SizedBox(height: 16.h),
              /// ============================================ line ====================================>
              CustomImageDetailsProgressBar(),








              SizedBox(height: 50.h)
            ],
          ),
        ),
      ),
    );
  }


}








