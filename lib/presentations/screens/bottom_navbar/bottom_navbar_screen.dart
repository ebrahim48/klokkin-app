import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klokkin_app/presentations/screens/home/home_screen.dart';
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
     HomeScreen(),

  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;

    return Scaffold(
      extendBody: true,
      backgroundColor: currentIndex == 0 ? Colors.transparent : AppColors.bgColorWhite,
      body: screens[currentIndex],
      bottomNavigationBar: Container(
        // height: sizeH * .08,
        // margin: EdgeInsets.all(sizeH * .015),
        padding: EdgeInsets.all(sizeH * .015),
        decoration: const BoxDecoration(
          color: AppColors.bgColorWhite,
          boxShadow: [
            BoxShadow(
                color: Color(0x1AE0001B),
                blurRadius: 8,
                offset: Offset(2, -5),
                spreadRadius: 3
            ),
          ],
        ),

        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, 'Home'),
              _buildNavItem(1, 'Story'),
              _buildNavItem(2, 'Library'),
              _buildNavItem(3, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label) {
    bool isSelected = index == currentIndex;
    List<Widget> icons = [
      Assets.icons.home.svg(color: isSelected ?  AppColors.bottomColorE9A431 : AppColors.textColor000000),
      Assets.icons.story.svg(color: isSelected ?  AppColors.bottomColorE9A431 : AppColors.textColor000000),
      Assets.icons.library.svg(color: isSelected ?  AppColors.bottomColorE9A431 : AppColors.textColor000000),
      Assets.icons.profile.svg(color: isSelected ?  AppColors.bottomColorE9A431 : AppColors.textColor000000),
    ];

    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icons[index],
          SizedBox(height: 4.h),
          CustomText(text:
            label,
            color: isSelected ? AppColors.bottomColorE9A431 : AppColors.textColor000000,
            fontsize: 12.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ],
      ),
    );
  }
}