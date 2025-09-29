import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:klokkin_app/core/config/app_routes/app_routes.dart';
import 'package:klokkin_app/presentations/screens/home/home_screen.dart';
import 'package:klokkin_app/presentations/screens/library/library_screen.dart';
import 'package:klokkin_app/presentations/screens/profile/profile_screen.dart';
import 'package:klokkin_app/presentations/screens/story/story_screen.dart';
import 'package:klokkin_app/presentations/widgets/custom_text.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../global/custom_assets/assets.gen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final List<Widget> screens = [
    const HomeScreen(),
    const StoryScreen() ,
     LibraryScreen(videoPath: '',),
   const ProfileScreen(),
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: currentIndex == 0
          ? Colors.transparent
          : AppColors.bgColorWhite,
      body: screens[currentIndex],

      floatingActionButton: SizedBox(
        width: 65.w,
        height: 65.w,
        child: FloatingActionButton(
          backgroundColor: const Color(0xFFE5A231),
          elevation: 4,
          shape: const CircleBorder(),
          onPressed: () {

          },
          child: Icon(
            Icons.add,
            size: 40.sp,
            color: AppColors.textColorFFFFFF,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: AppColors.bgColorWhite,
        elevation: 8,
        child: SafeArea(
          child: SizedBox(
            height: 65.h,
            child: Row(
              children: [

                Expanded(child: _buildNavItem(0, 'Home')),
                Expanded(child: _buildNavItem(1, 'Story')),
                 SizedBox(width: 65.w),
                Expanded(child: _buildNavItem(2, 'Library')),
                Expanded(child: _buildNavItem(3, 'Profile')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label) {
    bool isSelected = index == currentIndex;
    List<Widget> icons = [
      Assets.icons.home.svg(
          color: isSelected
              ? AppColors.bottomColorE9A431
              : AppColors.textColor000000),
      Assets.icons.story.svg(
          color: isSelected
              ? AppColors.bottomColorE9A431
              : AppColors.textColor000000),
      Assets.icons.library.svg(
          color: isSelected
              ? AppColors.bottomColorE9A431
              : AppColors.textColor000000),
      Assets.icons.profileIcon.svg(
          color: isSelected
              ? AppColors.bottomColorE9A431
              : AppColors.textColor000000),
    ];

    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: SizedBox(
        height: 60.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icons[index],
            SizedBox(height: 4.h),
            CustomText(
              text: label,
              color: isSelected
                  ? AppColors.bottomColorE9A431
                  : AppColors.textColor000000,
              fontsize: 12.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ],
        ),
      ),
    );
  }
}
