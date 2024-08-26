import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmberry_project/consts/consts.dart';
import 'package:farmberry_project/controllers/cart_controller.dart';
import 'package:farmberry_project/services/firestore_services.dart';
import 'package:farmberry_project/views/cart_screen/shipping_screen.dart';
import 'package:farmberry_project/widgets_common/loading_indicator.dart';
import 'package:farmberry_project/widgets_common/our_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(cartController());
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 60,
        child: ourButton(
          color: greenColor,
          onPress: () {
            Get.to(() => shippingDetails());
          },
          textColor: whiteColor,
          title: "Process to shipping",
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: "Shopping Cart".text.fontFamily(semibold).color(darkFontGrey).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getCart(currentUser!.uid) ,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          }

          else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: "Cart is empty".text.color(darkFontGrey).make(),
            );
          }

          else {
            var data = snapshot.data!.docs;
            controller.calculate(data);
            controller.productSnapshot = data;

            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: Image.network(
                                  '${data[index]['img']}',
                              width: 80,
                              fit: BoxFit.cover,),
                              title: "${data[index]['title']}".text.fontFamily(semibold).color(darkFontGrey).make(),
                              subtitle: "${data[index]['tprice']}".numCurrency.text.fontFamily(semibold).color(redColor).make(),

                              trailing: Icon(Icons.delete, color: redColor).onTap(() {

                                FirestoreServices.deleteDocument(data[index].id);




                              }),
                            );
                          })),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "Total Price"
                          .text
                          .color(darkFontGrey)
                          .fontFamily(semibold)
                          .make(),

                      Obx(
          () => "${controller.totalP.value}"
                            .numCurrency
                            .text
                            .color(greenColor)
                            .fontFamily(semibold)
                            .make(),
                      )
                    ],
                  ).box
                      .color(lightgolden)
                      .padding(EdgeInsets.all(12))
                      .width(context.screenWidth - 60)
                      .roundedSM
                      .make(),
                  10.heightBox,
                  // SizedBox(
                  //   width: context.screenWidth - 60,
                  //   child: ourButton(
                  //     color: greenColor,
                  //     onPress: () {},
                  //     textColor: whiteColor,
                  //     title: "Process to shipping",
                  //   ),
                  // )
                ],
              ),
            );
          }
        }
      )
    );
  }
}


