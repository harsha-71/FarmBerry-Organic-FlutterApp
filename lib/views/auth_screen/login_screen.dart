import 'package:farmberry_project/consts/consts.dart';
import 'package:farmberry_project/consts/lists.dart';
import 'package:farmberry_project/controllers/auth_controller.dart';
import 'package:farmberry_project/views/auth_screen/signup_scrren.dart';
import 'package:farmberry_project/views/home_screen/home.dart';
import 'package:farmberry_project/widgets_common/applogo_widget.dart';
import 'package:farmberry_project/widgets_common/bg_widget.dart';
import 'package:farmberry_project/widgets_common/custom_textfield.dart';
import 'package:farmberry_project/widgets_common/our_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login_Screen extends StatelessWidget {
  const Login_Screen({super.key});

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(AuthController());

    return bg_Widget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              applogoWidget(),
              10.heightBox,
              "Log in to $appname".text.fontFamily(bold).black.size(14).make(),
              15.heightBox,

              Obx(
                  () => Column(
                  children: [
                    customTextField(hint: emailHint, title: email, isPass: false, controller: controller.emailController),
                    customTextField(hint: passwordHint, title: password, isPass: true, controller: controller.passwordController),

                    Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(onPressed:  () {}, child:forgetPassword.text.make(),)),
                        5.heightBox,
                            controller.isLoading.value?
                            const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(greenColor),
                            ):
                            ourButton(
                   color: greenColor,
                   title: login,
                   textColor: whiteColor,
                   onPress: () async  {
                  controller.isLoading(true);
                  await controller.loginMethod(context: context).then((value){
                    if(value != null)
                       {
                       VxToast.show(context, msg: loggedin);
                        Get.to(()=>Home());
                       }
                    else{
                      controller.isLoading(false);
                    }
                   });

                },
                            ).box.width(context.screenWidth - 50).make(),
                        5.heightBox,
                        createNewAccount.text.color(blueColor).make(),
                        5.heightBox,
                    ourButton(color: lightgreen, title: signup, textColor: greenColor, onPress: (){
                      Get.to(() => const SignUp_Screen());
                      }, ).box.width(context.screenWidth-50).make(),

                    10.heightBox,
                    loginWith.text.color(fontGrey).make(),
                    5.heightBox,


                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                        List.generate(
                                 3,
                                (index) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    backgroundColor: lightGrey,
                                    radius: 25,
                                    child: Image.asset(socialIconList[index], width: 30,),
                                  ),
                                )),

                    ),


                  ],
                ).box.white.rounded.padding(const EdgeInsets.all(20)).width(context.screenWidth-70).shadowSm.make(),
              ),

            ],
          ),
        ),

      )
    );
  }
}

