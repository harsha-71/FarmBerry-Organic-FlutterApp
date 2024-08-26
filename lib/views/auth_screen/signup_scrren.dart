import 'dart:html';

import 'package:farmberry_project/consts/consts.dart';
import 'package:farmberry_project/controllers/auth_controller.dart';
import 'package:farmberry_project/views/home_screen/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../consts/lists.dart';
import '../../widgets_common/applogo_widget.dart';
import '../../widgets_common/bg_widget.dart';
import '../../widgets_common/custom_textfield.dart';
import '../../widgets_common/our_button.dart';

class SignUp_Screen extends StatefulWidget {
  const SignUp_Screen({super.key});

  @override
  State<SignUp_Screen> createState() => _SignUp_ScreenState();
}

class _SignUp_ScreenState extends State<SignUp_Screen> {
  bool? isCheck = false;
  var controller = Get.put(AuthController());

  //text controllers
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return bg_Widget(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
            child: Column(
              children: [
                (context.screenHeight * 0.1).heightBox,
                applogoWidget(),
                10.heightBox,
                "Join the $appname".text
                    .fontFamily(bold)
                    .black
                    .size(14)
                    .make(),
                15.heightBox,

                Obx(
                    ()=> Column(

                    children: [

                      customTextField(hint: nameHint, title: name, controller: nameController, isPass: false),
                      customTextField(hint: emailHint, title: email, controller: emailController, isPass: false),
                      customTextField(hint: passwordHint, title: password, controller: passwordController, isPass: true),
                      customTextField(hint: passwordHint, title: retypePassword, controller: passwordRetypeController, isPass: true),

                      Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {}, child: forgetPassword.text
                              .make(),)),
                      5.heightBox,
                      // ourButton().box.width(context.screenWidth - 50).make(),
                      // ourButton(color: greenColor, title: login, textColor: whiteColor, onPress: (){}).box.width(context.screenWidth-50).make()

                      //adding checkbox
                      Row(
                        children: [
                          Checkbox(
                            checkColor: greenColor,
                            value: isCheck,
                            onChanged: (newValue){
                              setState(() {
                                isCheck = newValue;
                              });
                            },
                          ),
                          5.widthBox,
                          Expanded(
                            child: RichText(text: TextSpan(
                              children: [
                                TextSpan(
                                    text: "I agree to the ", style: TextStyle(
                                  fontFamily: regular,
                                  color: fontGrey,

                                )),
                                TextSpan(
                                    text: termAndConditions,
                                    style: TextStyle(
                                      fontFamily: regular,
                                      color: greenColor,

                                    )),
                                TextSpan(
                                    text: "& ", style: TextStyle(
                                  fontFamily: regular,
                                  color: fontGrey,

                                )),
                                TextSpan(
                                    text: privacyPolicy,
                                    style: TextStyle(
                                      fontFamily: regular,
                                      color: greenColor,
                                    )),
                              ],
                            )),
                          ),
                        ],

                      ),

                      //adding button
                      controller.isLoading.value? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(greenColor),
                      ):ourButton(
                        color: isCheck == true? greenColor:lightGrey,
                        title: signup,
                        textColor: whiteColor,
                        onPress: () async {
                          if(isCheck != false){
                            controller.isLoading(true);
                            try{
                              await controller.signupMethod(context: context, email: emailController.text, password: passwordController.text).then((value){
                                return controller.storeUserData(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  name: nameController.text,
                                );
                              }).then((value){
                                VxToast.show(context, msg: loggedin);
                                Get.offAll(() => Home());
                              });

                              }catch (e) {
                              auth.signOut();
                              VxToast.show(context, msg: e.toString());
                              controller.isLoading(false);

                              }
                            }

                        },

                      ).box.width(context.screenWidth - 50)
                          .make(),
                      10.heightBox,
                      //wrapping into gesture detector  widget into velocity x

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          allReadyHaveAcc.text.color(fontGrey).make(),
                          login.text.color(greenColor).make().onTap(() {
                            Get.back();
                          })
                        ],
                      )

                      // RichText(text: TextSpan(
                      //   children: [
                      //     TextSpan(text: allReadyHaveAcc,
                      //         style: TextStyle(
                      //           fontFamily: bold,
                      //           color: fontGrey,
                      //         )),
                      //     TextSpan(text: login,
                      //         style: TextStyle(
                      //           fontFamily: bold,
                      //           color: greenColor,
                      //         )),
                      //   ],
                      // ),
                      // ).onTap(() { Get.back();})


                    ],
                  ).box.white.rounded
                      .padding(const EdgeInsets.all(20))
                      .width(context.screenWidth - 70)
                      .shadowSm
                      .make(),
                ),

              ],
            ),
          ),

        )
    );
  }
}

