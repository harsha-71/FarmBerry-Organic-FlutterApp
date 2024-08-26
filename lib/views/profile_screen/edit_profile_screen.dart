
import 'dart:io';
import 'package:farmberry_project/consts/consts.dart';
import 'package:farmberry_project/controllers/profile_controller.dart';
import 'package:farmberry_project/widgets_common/bg_widget.dart';
import 'package:farmberry_project/widgets_common/custom_textfield.dart';
import 'package:farmberry_project/widgets_common/our_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../consts/images.dart';

class editProfileScreen extends StatelessWidget {
  final dynamic data;
  const editProfileScreen({super.key, this.data});
  @override
  Widget build(BuildContext context) {

    var controller = Get.find<ProfileController>();

    return bg_Widget(
      child: Scaffold(
        appBar: AppBar(),
        body: Obx(() =>Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              controller.profileImagePath.isNotEmpty

             ? Image.asset(imgProfile2, width: 100, fit: BoxFit.cover).box.roundedFull.clip(Clip.antiAlias).make()
              :Image.network(
            controller.profileImagePath.value,
                width: 100,
                fit: BoxFit.cover,
              ).box.roundedFull.clip(Clip.antiAlias).make(),

              10.heightBox,
              ourButton(color: greenColor,
                  onPress: (){
                controller.changeImg(context);

              },
                  textColor: whiteColor,
                  title: "Change"),
              Divider(),
              20.heightBox,
              customTextField(controller: controller.nameController ,hint: nameHint, title: name, isPass: false),
              customTextField(controller : controller.passController,hint: passwordHint, title: password, isPass: true),
              20.heightBox,
              controller.isLoading.value
              ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(redColor),
              )
              : SizedBox(
                width: context.screenWidth-60,
                  child: ourButton(color: greenColor,
                      onPress: () async{

                    controller.isLoading(true);

                    await controller.uploadProfileImage();
                    await controller.updateProfile(
                    imgUrl:controller.profileImageLink,
                        name: controller.nameController.text,
                      password: controller.passController.text);
                    VxToast.show(context, msg: "Your profile updated successfully!");

                  }, textColor: whiteColor,title: "Save")),

            ],
          ).box.white.shadowLg.rounded.padding(EdgeInsets.all(16)).margin(EdgeInsets.only(top: 50, left: 12, right: 12)).make(),
        ),

      )
    );
  }
}
