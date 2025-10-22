import 'dart:convert';

import 'package:get/get.dart';
import '../../services/api_client.dart';
import '../models/notification_model.dart';



class NotificationsController extends GetxController{


  RxInt page = 1.obs;
  var totalPage = (-1);
  var currentPage = (-1);
  var totalResult = (-1);

  void loadMore() {
    print("==========================================total page ${totalPage} page No: ${page.value} == total result ${totalResult}");
    if (totalPage > page.value) {
      page.value += 1;
      getNotifications();
      print("**********************print here");
      update();
    }
    print("**********************print here**************");
  }

  RxBool notificationLoading = false.obs;
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;



  getNotifications() async {
    if (page.value == 1) {
      notificationLoading(true);
    }

    var response = await ApiClient.getData("/notification/?page=${page.value}");

    if (response.statusCode == 200) {
      final res = response.body;

      final attributes = res["data"]["attributes"];

      totalPage = int.tryParse(attributes["totalPages"].toString()) ?? 0;
      currentPage = int.tryParse(attributes["page"].toString()) ?? 0;
      totalResult = int.tryParse(attributes["totalResults"].toString()) ?? 0;

      final results = attributes["results"] as List? ?? [];
      final data = results.map((x) => NotificationModel.fromJson(x)).toList();

      if (page.value == 1) {
        notifications.assignAll(data);
      } else {
        notifications.addAll(data);
      }

      update();
      notificationLoading(false);
    } else {
      notificationLoading(false);
    }
  }




}