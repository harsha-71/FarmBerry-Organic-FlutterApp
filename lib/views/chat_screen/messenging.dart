import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmberry_project/views/chat_screen/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:farmberry_project/consts/consts.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../services/firestore_services.dart';
import '../../widgets_common/loading_indicator.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "My messages".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getAllMessages(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: "No messages yet!".text.color(darkFontGrey).make(),
            );
          } else {
            var data = snapshot.data!.docs;
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                      child:ListView.builder(
                        itemCount: data.length,
                          itemBuilder: (BuildContext context, int index){
                          return Card(
                            child: ListTile(
                              onTap: () {
                                Get.to(() => chatScreen(),
                                arguments: [
                                  data[index]['friend_name'],
                                    data[index]['toId']
                                    ],
                                );

                              },
                              leading: CircleAvatar(
                                backgroundColor: greenColor,
                                child: Icon(
                                  Icons.person,
                                  color: whiteColor,
                                ),
                              ),
                              title: "${data[index]['friend_name']}".text.fontFamily(semibold).color(darkFontGrey).make(),
                              subtitle: "${data[index]['last_msg']}".text.make(),
                            ),
                          );
                          })
                  )
                ],



              ),
            );
          }
        },
      ),
    );
  }
}
