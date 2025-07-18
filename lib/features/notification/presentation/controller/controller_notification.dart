import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/features/notification/data/data_sources/notification_data_source.dart';

abstract class NotificationsController extends GetxController {
  Future<String> getToken();
  void getNotification();
  Future SendTokenNotification();
}

class ControllerNotifications extends NotificationsController {
  final NotificationDataSourceImpl _notificationDataSourceImpl =
      NotificationDataSourceImpl(Get.find());
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final MyServices _myServices = Get.find();
  String? token;
  bool notification = true;

  @override
  Future<String> getToken() async {
    token = await _firebaseMessaging.getToken();
    return token!;
  }

  @override
  void getNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        // عرض إشعار في التطبيق
        Get.snackbar(
          '',
          '',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 5),
          titleText: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 80,
                height: 48,
                child: Image.asset("images/logoNylon.png", fit: BoxFit.cover),
              ),
              const SizedBox(width: 10),
              // جعل النص يتكيف مع المساحة المتاحة
              Text(
                '${message.notification!.title}',
                style: Theme.of(Get.context!).textTheme.bodyMedium,
                maxLines: 5, // تحديد عدد الأسطر في العنوان
                overflow: TextOverflow.ellipsis, // إضافة ... عند تجاوز النص
              ),
            ],
          ),
          backgroundColor: Colors.white,
          messageText: Column(
            children: [
              Text(
                '${message.notification!.body}',
                style: Theme.of(Get.context!).textTheme.bodySmall,
                maxLines: 5, // تحديد عدد الأسطر في النص
                overflow: TextOverflow.ellipsis, // إضافة ... عند تجاوز النص
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: 10, vertical: 20), // زيادة padding لزيادة المساحة
          margin:
              const EdgeInsets.all(10), // زيادة margin للحصول على مساحة أكبر
        );
        update(); // لتحديث الواجهة عند وصول إشعار جديد
      }
    });

    // استماع عندما يكون التطبيق في الخلفية أو مغلق
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked: ${message.notification!.title}');
    });
  }

  // طلب إذن الإشعارات
  Future<void> per() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    update();
  }

  void isNotificationVoid({required bool value}) {
    notification = value;
    getNotification();
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getToken().then((value) async {
      SendTokenNotification();
      _myServices.sharedPreferences.setString('DeviceId', token!);
    });

    per();

    getNotification();
  }

  s() {}

  @override
  Future SendTokenNotification() async {
    var isToken = _myServices.sharedPreferences.getString("DeviceId");
    if (isToken != null) {
      print('التوكين مووووووووووووووووووووووووووووجود');
      return;
    } else {
      var response = await _notificationDataSourceImpl.SendTokenNotification(
          token: token!);
      return response.fold((faliure) {
        print("errorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
        print(faliure);
      }, (data) {
        print(data);
        print('ssssssssssssssssssssssssssssssssssssssssssend Token Notf');
      });
    }
  }
}
