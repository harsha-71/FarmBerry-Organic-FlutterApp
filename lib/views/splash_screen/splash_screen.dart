import 'package:farmberry_project/consts/colors.dart';
import 'package:farmberry_project/consts/consts.dart';
import 'package:farmberry_project/views/auth_screen/login_screen.dart';
import 'package:farmberry_project/views/home_screen/home.dart';
import 'package:farmberry_project/widgets_common/applogo_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {

  changeScreen()
  {
    Future.delayed(const Duration(seconds: 3),(){
      //using getx
      // Get.to(() => const Login_Screen());
      auth.authStateChanges().listen((User? user) {
        if(user == null && mounted)
          {
            Get.to(() => Login_Screen());
          }
        else{
          Get.to(() => Home());
        }
      });
    });
  }

  void initState()
  {
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greenColor,
      body: Center(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Image.asset(icSplashBg, width: 200)),
            10.heightBox,
            applogoWidget(),
            10.heightBox,
            appname.text.fontFamily(bold).size(22).white.make(),
            appversion.text.white.make(),
            Spacer(),
            credits.text.white.fontFamily(semibold).make(),
            30.heightBox,

            //our splash screen UI is created..

          ],
        ),
      ),
    );
  }
}
