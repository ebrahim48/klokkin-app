import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import '../../../controllers/audio_book_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../global/custom_assets/assets.gen.dart';
import '../../widgets/bookmark_Innovation_widget.dart';
import '../../widgets/bookmark_factory_widget.dart';
import '../../widgets/custom_loader.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
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
        child: Obx(() {
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
            physics: const BouncingScrollPhysics(),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(bottom: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ==============================> Header ===================================>
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        CustomText(
                          text: 'BookMark',
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
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Divider(
                      thickness: 1,
                      color: const Color(0x36D09F48),
                      height: 0.h,
                    ),
                  ),

                  /// ==============================> Horizontal List ===================================>
                  SizedBox(height: 20.h),
                  SizedBox(
                    height: 160.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      itemCount: controller.libraryStoryData.length,
                      separatorBuilder: (context, index) => SizedBox(width: 12.w),
                      itemBuilder: (context, index) {
                        final libraryData = controller.libraryStoryData[index];
                        return BookmarkInnovationCard(
                          id: '${libraryData.id}',
                          title: libraryData.caption ?? 'N/A',
                          caption: libraryData.description ?? 'N/A',
                          imagePath: libraryData.mediaUrl != null && libraryData.mediaUrl!.isNotEmpty
                              ? libraryData.mediaUrl!.first
                              : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                          onTap: () {

                          },
                        );
                      },
                    ),
                  ),

                  /// Divider
                  Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 15.h),
                    child: Divider(
                      color: AppColors.secondary836531,
                      height: 0.4.h,
                      thickness: 0.6,
                    ),
                  ),
                  SizedBox(height: 11.h),

                  /// ==============================> Grid ===================================>
                  GridView.builder(
                    shrinkWrap: true, // Important
                    physics: const NeverScrollableScrollPhysics(), // disable own scroll
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12.h,
                      crossAxisSpacing: 12.w,
                      childAspectRatio: 140.w / 180.h,
                    ),
                    itemCount: controller.libraryStoryData.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      final libraryFactoryData = controller.libraryStoryData[index];
                      return BookmarkFactoryCard(
                        id: '${libraryFactoryData.id}',
                        title: libraryFactoryData.caption ?? 'N/A',
                        caption: libraryFactoryData.description ?? 'N/A',
                        imagePath: libraryFactoryData.mediaUrl != null && libraryFactoryData.mediaUrl!.isNotEmpty
                            ? libraryFactoryData.mediaUrl!.first
                            : "https://templates.joomla-monster.com/joomla30/jm-news-portal/components/com_djclassifieds/assets/images/default_profile.png",
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
