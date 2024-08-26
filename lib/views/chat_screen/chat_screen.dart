import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmberry_project/consts/consts.dart';
import 'package:farmberry_project/services/firestore_services.dart';
import 'package:farmberry_project/views/chat_screen/controller/chat_controller.dart';
import 'package:farmberry_project/views/chat_screen/controller/sender_bubble.dart';
import 'package:farmberry_project/widgets_common/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class chatScreen extends StatelessWidget{

  const chatScreen({super.key});

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(chatController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: "${controller.friendName}".text.fontFamily(semibold).color(darkFontGrey).make(),
      ),

      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                  child: StreamBuilder(
                    stream: FirestoreServices.getChatMessages(controller.chatDocId.toString()),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: loadingIndicator());
                      } else if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: "Send a message...".text.color(darkFontGrey).make(),
                        );
                      } else {
                        return ListView(
                          children: snapshot.data!.docs.mapIndexed((currentValue, index) {
                            var data = snapshot.data!.docs[index];

                            return Align(
                              alignment: data['uid'] == currentUser!.uid
                                ?Alignment.centerRight
                                :Alignment.centerLeft,
                                child: senderBubble(data));
                          }).toList(),

                            );
                          }
                      },
                    )
        ),


            10.heightBox,
            Row(
              children: [
                Expanded(child: TextField(
                  controller: controller.msgController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: textfieldGrey,
                      )),
                    focusedBorder:  OutlineInputBorder(
                        borderSide: BorderSide(
                          color: textfieldGrey,
                        )),
                    hintText: "Type a message...",
                  ),
                )),IconButton(onPressed: (){

                  controller.sendMsg(controller.msgController.text);
                  controller.msgController.clear();

                }, icon: Icon(Icons.send, color: greenColor,)),
              ],
            ).box.height(80).padding(EdgeInsets.all(12)).margin(EdgeInsets.only(bottom: 8)).make()
          ],
        ),
      ),

    );
  }
}
