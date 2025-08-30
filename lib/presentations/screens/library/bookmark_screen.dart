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


class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {

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
                      text: 'BookMark',
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
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Divider(
                  thickness: 1,
                  color: const Color(0x36D09F48),
                  height: 0.h,
                ),
              ),

              /// =====================================> Card =====================================>
              SizedBox(height: 20.h),

              SizedBox(
                height: 160.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: 6,
                  separatorBuilder: (context, index) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    return BookmarkInnovationCard(
                      title: "Innovation",
                      caption: " In this unique workspace.",
                      imagePath: "assets/images/imageStory.png",
                      onTap: () {
                        context.pushNamed(AppRoutes.storyImageDetailsScreen);
                        // Example navigation
                        // context.pushNamed(AppRoutes.storyDetails, extra: {...});
                      },
                    );
                  },
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
                height: 390.h,
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12.h,
                    crossAxisSpacing: 12.w,
                    childAspectRatio: 140.w / 180.h,
                  ),
                  itemCount: 12,
                  reverse: true,
                  itemBuilder: (context, index) {
                    return BookmarkFactoryCard(
                      title: "Factory Life",
                      caption: "Forging the Future in the Glow of the past",
                      imagePath: "assets/images/unsplash.png",
                      onTap: () {
                        // Example navigation
                        // context.pushNamed(AppRoutes.storyDetails, extra: {...});
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



