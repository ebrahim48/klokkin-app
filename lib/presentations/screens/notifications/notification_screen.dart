import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/notifications_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/custom_loader.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/notifications_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.arrow_back, color: AppColors.textColorFFFFFF, size: 24.r),
              onPressed: () => Navigator.pop(context),
            ),
            SizedBox(width: 12.w),
            CustomText(
              text: "Notifications",
              color: AppColors.textColorFFFFFF,
              fontsize: 24.sp,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),

      ),
      body:  Obx(()=>
      notificationsController.notificationLoading.value ? const CustomLoader() :
      notificationsController.notifications.isEmpty ? Center(child: CustomText(text: "No Notification Found!")) :
       ListView.builder(
         controller: _scrollController,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          itemCount: notificationsController.notifications.length,
          itemBuilder: (context, index) {
            var notification = notificationsController.notifications[index];
            return NotificationItemWidget(
              title: notification.title ?? '',
              role: notification.role ?? '',
              time: notification.createdAt != null
                  ? DateFormat('yyyy-MM-dd HH:mm').format(notification.createdAt!)
                  : '',



            );
          },
        ),),
    );
  }



  NotificationsController notificationsController = Get.put(NotificationsController());

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    notificationsController.getNotifications();
    super.initState();
    _addScrollListener();
  }

  void _addScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        notificationsController.loadMore();
        print("==========test========load more true");
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}


