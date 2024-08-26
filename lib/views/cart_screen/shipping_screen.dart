import 'package:farmberry_project/consts/consts.dart';
import 'package:farmberry_project/controllers/cart_controller.dart';
import 'package:farmberry_project/views/cart_screen/payment_method.dart';
import 'package:farmberry_project/widgets_common/custom_textfield.dart';
import 'package:farmberry_project/widgets_common/our_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matcher/matcher.dart';

class shippingDetails extends StatelessWidget {
  const shippingDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<cartController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: "Shipping Info".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 50,
        child: ourButton(
          onPress: () {
            if(controller.addressController.text.length > 10)
              {
                //&& controller.cityController.text.length <= 8 && controller.postalcodeController.text.length == 6 && controller.phoneController.text.length == 10
                Get.to(() => paymentMethod());

              }else{
              VxToast.show(context, msg: "Please fill the form correctly!");
            }
          },
          color: greenColor,
          textColor: whiteColor,
          title: "Continue"
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            customTextField(hint: "Address", isPass: false, title: "Address", controller: controller.addressController),
            customTextField(hint: "City", isPass: false, title: "City", controller: controller.cityController),
            customTextField(hint: "State", isPass: false, title: "State", controller: controller.stateController),
            customTextField(hint: "Postal Code", isPass: false, title: "Postal Code", controller: controller.postalcodeController),
            customTextField(hint: "Phone", isPass: false, title: "Phone", controller: controller.phoneController)
          ],
        ),
      ),
    );
  }
}
