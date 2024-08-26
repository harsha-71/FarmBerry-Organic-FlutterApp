import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmberry_project/consts/consts.dart';
import 'package:farmberry_project/consts/lists.dart';
import 'package:farmberry_project/controllers/auth_controller.dart';
import 'package:farmberry_project/controllers/profile_controller.dart';
import 'package:farmberry_project/services/firestore_services.dart';
import 'package:farmberry_project/views/auth_screen/login_screen.dart';
import 'package:farmberry_project/views/chat_screen/messenging.dart';
import 'package:farmberry_project/views/orders_screen/orders_screen.dart';
import 'package:farmberry_project/views/orders_screen/wishlist_screen.dart';
import 'package:farmberry_project/views/profile_screen/components/details.cart.dart';
import 'package:farmberry_project/views/profile_screen/edit_profile_screen.dart';
import 'package:farmberry_project/widgets_common/bg_widget.dart';
import 'package:farmberry_project/widgets_common/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());

    return bg_Widget(
      child: Scaffold(
        body:  StreamBuilder(
          stream: FirestoreServices.getUser(currentUser!.uid),

          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(greenColor),
              ),
              );
            }
            else{
              var data = snapshot.data!.docs[0];

              return SafeArea(
                child: Column(
                  children: [
                    //edit profile button
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(alignment: Alignment.topRight,
                          child: Icon(Icons.edit, color: whiteColor)).onTap(() {

                            controller.nameController.text = data['name'];
                            controller.passController.text = data['password'];

                        Get.to(() => editProfileScreen(data: data,));

                      }),
                    ),

                    //user details section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80),
                      child: Row(
                        children: [



                          Image.asset(imgProfile2, width: 100, fit: BoxFit.cover).box.roundedFull.clip(Clip.antiAlias).make(),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "${data['name']}".text.fontFamily(semibold).white.make(),
                              "${data['email']}".text.white.make(),
                            ],
                          )),
                          OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: whiteColor,
                                  )
                              ),
                              onPressed: () async {
                                await Get.put(AuthController()).signOutMethod(context);
                                Get.offAll(() => Login_Screen());
                              },
                              child: logout.text.fontFamily(semibold).white.make())

                        ],
                      ),
                    ),
                    //history details
                    20.heightBox,
                    FutureBuilder(
                        future: FirestoreServices.getCounts(),
                        builder: (BuildContext context, AsyncSnapshot snapshot){
                          if(!snapshot.hasData){
                            return Center(child: loadingIndicator());
                          }
                          else {
                            var countData = snapshot.data;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                detailCart(
                                    count: countData[0].toString(),
                                    title: "in your cart",
                                    width: context.screenWidth / 3.4),
                                detailCart(
                                    count: countData[1].toString(),
                                    title: "in your wishlist",
                                    width: context.screenWidth / 3.4),
                                detailCart(
                                    count: countData[2].toString(),
                                    title: "your orders",
                                    width: context.screenWidth / 3.4),
                              ],
                            );
                          }

                        }),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
                    //   children: [
                    //     detailCart(count: data['cart_count'], title: "in your cart", width: context.screenWidth/3.4),
                    //     detailCart(count: data['wishlist_count'], title: "in your wishlist", width: context.screenWidth/3.4),
                    //     detailCart(count: data['order_count'], title: "your orders", width: context.screenWidth/3.4),
                    //   ],
                    // ),

                    //buttons section

                    ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index){
                          return Divider(
                            color: lightGrey,
                          );
                        },
                        itemCount: profileButtonList.length,

                        itemBuilder: (BuildContext context, int index)
                        {
                          return ListTile(
                            onTap: (){
                             switch(index){
                               case 0:
                                 Get.to(() => orderScreen());
                                 break;
                               case 1:
                                 Get.to(() => WishListScreen());
                                 break;
                               case 2:
                                 Get.to(() => MessagesScreen());
                                 break;
                             }
                            },
                            leading: Image.asset(profileButtonIcons[index],
                              width: 22,),
                            title: profileButtonList[index].text.fontFamily(semibold).color(darkFontGrey).make(),
                          );
                        }).box.rounded.margin(EdgeInsets.all(12)).padding(EdgeInsets.symmetric(horizontal: 16)).color(whiteColor).shadowSm.make().box.color(greenColor).make(),

                  ],
                ),
              );

            }

          },
        ),
      ),
    );
  }
}
