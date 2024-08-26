import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmberry_project/consts/consts.dart';
import 'package:farmberry_project/services/firestore_services.dart';
import 'package:farmberry_project/views/orders_screen/orders_detail.dart';
import 'package:farmberry_project/widgets_common/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class orderScreen extends StatelessWidget {
  const orderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "My Orders".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getAllOrders(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: "No orders yet!".text.color(darkFontGrey).make(),
            );
          } else {
            var data = snapshot.data!.docs;

            return ListView.builder(

              itemCount: data.length,
                itemBuilder: (BuildContext context, int index){
                return ListTile(
                  leading: '${index + 1}'.text.fontFamily(bold).color(darkFontGrey).xl.make(),
                  title: data[index]['order_code'].toString().text.color(greenColor).fontFamily(semibold).make(),
                  subtitle: data[index]['total_amount'].toString().numCurrency.text.fontFamily(bold).make(),
                  trailing: IconButton(onPressed: () {
                    Get.to(() => OrderDetails(data: data[index],));
                  },
                  icon: Icon(Icons.arrow_forward_ios_rounded, color: darkFontGrey,))
                );
                });

          }
        },
      ),
    );
  }
}