import 'package:farmberry_project/consts/consts.dart';
import 'package:farmberry_project/consts/lists.dart';
import 'package:farmberry_project/controllers/cart_controller.dart';
import 'package:farmberry_project/views/home_screen/home.dart';
import 'package:farmberry_project/widgets_common/loading_indicator.dart';
import 'package:farmberry_project/widgets_common/our_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';



class paymentMethod extends StatelessWidget {
  const paymentMethod({super.key});

  @override
  Widget build(BuildContext context) {

    var controller = Get.find<cartController>();

    return Obx(
      () =>  Scaffold(
        backgroundColor: whiteColor,
        bottomNavigationBar: SizedBox(
          height: 60,
          child: controller.placingOrder.value ? Center(
            child: loadingIndicator(),
          )
          :ourButton(
            onPress: () async {
              controller.placeMyOrder(
                  orderPaymentMethod: paymentMethods[controller.paymentIndex.value],
                  totalAmount: controller.totalP.value);
              await controller.clearCart();
              VxToast.show(context, msg: 'Order placed Successfully!');
              Get.offAll(Home());
            },
            color: greenColor,
            textColor: whiteColor,
            title: "Place Order",
          ),
        ),
        appBar: AppBar(
          title: "Choose Payment Method".text.fontFamily(semibold).color(darkFontGrey).make(),
        ),
        body: Padding(
          padding: EdgeInsets.all(12.0),

          child: Obx(
              () => Column(
              children:
                List.generate(paymentMethodImg.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        controller.changePaymentIndex(index);
                      },

                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: controller.paymentIndex.value == index ? redColor : Colors.transparent,
                            width: 4,
                          )),
                        margin: EdgeInsets.only(bottom: 8),

                        child: Stack(
                          alignment: Alignment.topRight,
                            children : [
                            Image.asset(
                                paymentMethodImg[index],
                                width: double.infinity ,
                                height:120,
                                colorBlendMode: controller.paymentIndex.value == index ? BlendMode.darken : BlendMode.color,
                                color:  controller.paymentIndex.value == index ? Colors.black.withOpacity(0.4): Colors.transparent,
                                fit: BoxFit.cover),
                              if (controller.paymentIndex.value == index) Transform.scale(
                                scale: 1.3,
                                child: Checkbox(
                                  activeColor: greenColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  value: true,
                                  onChanged: (value) {},),
                              )
                              else Container(),

                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: paymentMethods[index].text.white.fontFamily(semibold).size(16).make(),

                              )
                          ],
                      ),

                      ),
                    );
                }),
            ),
          ),
        ),
      ),
    );
  }
}
