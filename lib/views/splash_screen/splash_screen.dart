import 'dart:async';

import 'package:app_thoitrang/consts/consts.dart';
import 'package:app_thoitrang/views/auth_screen/login_screen.dart';
import 'package:app_thoitrang/views/home_screen/home.dart';
import 'package:app_thoitrang/widgets_common/applogo_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:velocity_x/velocity_x.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //change screen 3s
  changeScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      //using getX
      // Get.to(() => const LoginScreen());
      auth.authStateChanges().listen((User? user) {
        if (user == null && mounted) {
          Get.to(() => const LoginScreen());
        } else {
          Get.to(() => const Home());
        }
      });
    });
  }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: redColor,
      body: Center(
        child: Column(
          children: [
            Container(),
            Image.asset(
              icSplashBg,
              width: 300,
            ),
            applogoWidget(),
            appname.text.fontFamily(bold).size(22).white.make(),
          ],
        ),
      ),
    );
  }
}
