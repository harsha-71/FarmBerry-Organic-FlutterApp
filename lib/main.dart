import 'dart:html';

import 'package:farmberry_project/views/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'consts/consts.dart';
import 'controllers/product_controller.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyC5hpJw47Pd8QCxiNWlfzHcUeDAmsRIAJk",
            appId: "1:429684599171:android:b77db88b77a42ee2a3aeb6",
            messagingSenderId: "429684599171",
            projectId: "myfarmberry"
        )
      );

   await Firebase.initializeApp();
  Get.put(ProductController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    //we are using the getx so insted of using the material app we need to use the getMaterial app
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appname,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: darkFontGrey,
          ),
          backgroundColor: Colors.transparent,
        ),
        fontFamily: regular,
      ),
      home: const Splash_Screen(),
    );
  }
}
