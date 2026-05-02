import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:optigo/config/routes.dart';

class SplashProvider extends ChangeNotifier {

  // Logic kiểm tra trạng thái đăng nhập
  Future<void> initSplash(Function(String) onComplete) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    // Đợi 3 giây để hiển thị Splash Screen
    await Future.delayed(const Duration(seconds: 3));

    String nextRoute;
    if (auth.currentUser != null) {
      nextRoute = Routes.home; // Quay về trang chủ '/'
    } else {
      nextRoute = Routes.login; // Hoặc CarbeRoutes.signin tùy logic dự án
    }

    // Thông báo cho View thực hiện điều hướng
    onComplete(nextRoute);
  }
}