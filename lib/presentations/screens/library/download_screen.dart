import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/config/app_routes/app_routes.dart';
import 'package:klokkin_app/presentations/widgets/custom_app_bar.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import '../../../core/constants/app_colors.dart';
import '../../../global/custom_assets/assets.gen.dart';
import '../../widgets/bookmark_Innovation_widget.dart';
import '../../widgets/bookmark_factory_widget.dart';
import '../../widgets/custom_profile_image.dart';
import '../../widgets/image_story_list_widget.dart';
import '../../widgets/image_story_widget.dart';
import '../../widgets/latest_card_widget.dart';
import '../../widgets/work_card_widget.dart';


class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ==============================> Book  ===================================>
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [

                    CustomText(
                      text: 'Downloading',
                      color: AppColors.primaryColorC79235,
                      fontsize: 24.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    Spacer(),

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




              /// =====================================> Card =====================================>
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [

                    CustomText(
                      text: 'My Downloads',
                      color: AppColors.primaryColorC79235,
                      fontsize: 24.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    Spacer(),

                    SizedBox(
                      width: 35.w,
                      child: Assets.icons.dot.svg(width: 22.w, height: 22.h),
                    ),
                  ],
                ),
              ),
              /// =====================================> Create Story =====================================>
              Padding(
                padding:  EdgeInsets.only(left: 20.w,right: 15.h),
                child: Divider(
                  color: AppColors.secondary836531,
                  height: 0.4.h,
                  thickness: 0.6,
                ),
              ),
              /// =====================================> Latest Scroll =====================================>
              SizedBox(height: 11.h),

              SizedBox(
                height: 400.h,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: 6,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    return ImageListCard(
                      title: "Innovation Finds Its Space",
                      subtitle:
                      "In this modern workspace, ideas flow freely. Every desk holds the start of a new story.",
                      meta: "4h ago • 21m read",
                      hashtags: "#Innovation   #tech   #engineer   #2010s",
                      imagePath: "assets/images/imagelist.png",
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
        ),
      ),
    );
  }
}



