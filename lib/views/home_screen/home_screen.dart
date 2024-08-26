import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmberry_project/consts/lists.dart';
import 'package:farmberry_project/controllers/home_controller.dart';
import 'package:farmberry_project/services/firestore_services.dart';
import 'package:farmberry_project/views/categories_screen/item_details.dart';
import 'package:farmberry_project/views/home_screen/components/featured_button.dart';
import 'package:farmberry_project/views/home_screen/components/search_screen.dart';
import 'package:farmberry_project/widgets_common/home_button.dart';
import 'package:farmberry_project/widgets_common/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:farmberry_project/consts/consts.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeController>();
    return Container(
      padding: const EdgeInsets.all(12),
      color: lightGrey,
      width: context.screenWidth,
      height: context.screenHeight,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 60,
              color: lightGrey,
              child: TextFormField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.search).onTap(() {
                    if (controller.searchController.text.isNotEmpty) {
                      Get.to(() => SearchScreen(
                        title: controller.searchController.text,
                      ));
                    }
                  }),
                  filled: true,
                  fillColor: whiteColor,
                  hintText: searchAnything,
                  hintStyle: TextStyle(color: textfieldGrey),
                ),
              ),
            ),

            SizedBox(height: 10),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Widgets inside SingleChildScrollView
                    10.heightBox,
                    VxSwiper.builder(
                      aspectRatio: 16 / 9,
                      autoPlay: true,
                      height: 150,
                      enlargeCenterPage: true,
                      itemCount: sliderList.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          sliderList[index],
                          fit: BoxFit.fill,
                        ).box.rounded.clip(Clip.antiAlias).margin(const EdgeInsets.symmetric(horizontal: 8)).make();
                      },
                    ),

                    // Row of buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(2, (index) => homeButton(
                        height: context.screenHeight * 0.15,
                        width: context.screenWidth / 2.5,
                        icon: index == 0 ? icTodaysDeal : icFlashDeal,
                        title: index == 0 ? todayDeal : flashSale,
                      )),
                    ),


                    // Three icon buttons
                    10.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(3, (index) => homeButton(
                          height: context.screenHeight * 0.15,
                          width: context.screenWidth / 3.5,
                          icon: index == 0
                              ? icTopCategories
                              : index == 1
                              ? icBrands
                              : icTopSeller,
                          title: index == 0
                              ? topCategories
                              : index == 1
                              ? brand
                              : topSellers)),
                    ),



                    // Three icon buttons
                    // 10.heightBox,
                    //
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: List.generate(3, (index) => homeButton(
                    //     height: context.screenHeight * 0.15,
                    //     width: context.screenWidth / 3.5,
                    //     icon: index == 0 ? topCategories : index == 1 ? icBrands : icTopSeller,
                    //     title: index == 0 ? topCategories : index == 1 ? brand : topSellers,
                    //   )),
                    // ),



                    // Featured Categories section
                    20.heightBox,
                    "Feature Categories".text.fontFamily(bold).align(TextAlign.center).maxFontSize(30).color(Colors.black).make(),
                    10.heightBox,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(3, (index) => Column(
                          children: [
                            featuredButton(icon: featuredImages1[index], title: featuredTitles1[index]),
                            10.heightBox,
                            featuredButton(icon: featuredImages2[index], title: featuredTitles2[index]),
                          ],
                        )).toList(),
                      ),
                    ),

                    // Featured Products section
                    20.heightBox,
                    Container(
                      padding: EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(color: greenColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          featuredProduct.text.white.fontFamily(bold).size(18).make(),
                          10.heightBox,
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: FutureBuilder(
                              future: FirestoreServices.getFeaturedProducts(),
                              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(
                                    child: loadingIndicator(),
                                  );
                                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                  return "No featured products".text.white.makeCentered();
                                } else {
                                  var featuredData = snapshot.data!.docs.where((doc) => doc['p_is_featured'] == true).toList();
                                  return Row(
                                    children: List.generate(
                                      featuredData.length,
                                          (index) => Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Image.network(
                                            featuredData[index]['p_images'][0],
                                            width: 130,
                                            height: 130,
                                            fit: BoxFit.cover,
                                          ),
                                          10.heightBox,
                                          "${featuredData[index]['p_name']}".text.size(16).fontFamily(semibold).color(darkFontGrey).make(),
                                          10.heightBox,
                                          "${featuredData[index]['p_price']}".numCurrency.text.size(16).fontFamily(semibold).color(redColor).make(),
                                        ],
                                      ).box.white.margin(EdgeInsets.symmetric(horizontal: 4)).roundedSM.padding(EdgeInsets.all(8)).make()
                                        .onTap(() {
                                          Get.to(() => ItemDetails(
                                              title:"${featuredData[index]['p_name']}",
                                              data: featuredData[index],
                                          ));
                                          })
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Third swiper and other widgets...
                    10.heightBox,
                    VxSwiper.builder(
                      aspectRatio: 16 / 9,
                      autoPlay: true,
                      height: 150,
                      enlargeCenterPage: true,
                      itemCount: secondSwiperList.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          secondSwiperList[index],
                          fit: BoxFit.fill,
                        ).box.rounded.clip(Clip.antiAlias).margin(const EdgeInsets.symmetric(horizontal: 8)).make();
                      },
                    ),

                    // StreamBuilder section
                    10.heightBox,
                    "All Products".text.fontFamily(semibold).color(darkFontGrey).size(16).align(TextAlign.start).make(),
                    StreamBuilder(
                      stream: FirestoreServices.allProducts(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return loadingIndicator();
                        } else {
                          var allProductsData = snapshot.data!.docs;
                          return GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: allProductsData.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              mainAxisExtent: 300,
                            ),
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    allProductsData[index]['p_images'][0],
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                  Spacer(),
                                  "${allProductsData[index]['p_name']}".text.fontFamily(semibold).color(darkFontGrey).make(),
                                  SizedBox(height: 10),
                                  "${allProductsData[index]['p_price']}".text.color(redColor).fontFamily(bold).size(16).make(),
                                  10.heightBox,
                                ],
                              ).box.white.margin(EdgeInsets.symmetric(horizontal: 4)).roundedSM.padding(EdgeInsets.all(12)).make().onTap(() {
                                Get.to(() => ItemDetails(
                                  title: "${allProductsData[index]['p_name']}",
                                  data: allProductsData[index],
                                ));
                              });
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:farmberry_project/consts/lists.dart';
// import 'package:farmberry_project/services/firestore_services.dart';
// import 'package:farmberry_project/views/categories_screen/item_details.dart';
// import 'package:farmberry_project/views/home_screen/components/featured_button.dart';
// import 'package:farmberry_project/widgets_common/home_button.dart';
// import 'package:farmberry_project/widgets_common/loading_indicator.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:farmberry_project/consts/consts.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       color: lightGrey,
//       width: context.screenWidth,
//       height: context.screenHeight,
//       child: SafeArea(
//         child: Column(
//           children: [
//             Container(
//               alignment: Alignment.center,
//               height: 60,
//               color: lightGrey,
//               child: TextFormField(
//                 decoration: const InputDecoration(
//                   border: InputBorder.none,
//                   suffixIcon: Icon(Icons.search),
//                   filled: true,
//                   fillColor: whiteColor,
//                   hintText: searchAnything,
//                   hintStyle: TextStyle(color: textfieldGrey),
//                 ),
//               ),
//             ),
//             SizedBox(height: 10),
//
//             Expanded(
//               child: SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: Column(
//                   children: [
//                     // Widgets inside SingleChildScrollView
//                     10.heightBox,
//                     VxSwiper.builder(
//                         aspectRatio: 16 / 9,
//                         autoPlay: true,
//                         height: 150,
//                         enlargeCenterPage: true,
//                         itemCount: sliderList.length,
//                         itemBuilder: (context, index) {
//                           return Image.asset(
//                             sliderList[index],
//                             fit: BoxFit.fill,
//                           ).box.rounded.clip(Clip.antiAlias).margin(const EdgeInsets.symmetric(horizontal: 8)).make();
//                         }),
//
//                     // Row of buttons
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: List.generate(2, (index) => homeButton(
//                         height: context.screenHeight * 0.15,
//                         width: context.screenWidth / 2.5,
//                         icon: index == 0 ? icTodaysDeal : icFlashDeal,
//                         title: index == 0 ? todayDeal : flashSale,
//                       )),
//                     ),
//
//                     // Second swiper and other widgets...
//                     // Three icon buttons
//                     10.heightBox,
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: List.generate(3, (index) => homeButton(
//                           height: context.screenHeight * 0.15,
//                           width: context.screenWidth / 3.5,
//                           icon: index == 0
//                               ? topCategories
//                               : index == 1
//                               ? icBrands
//                               : icTopSeller,
//                           title: index == 0
//                               ? topCategories
//                               : index == 1
//                               ? brand
//                               : topSellers)),
//                     ),
//
//
//                     // Featured Categories section
//                     20.heightBox,
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children:
//                           List.generate(3, (index) => Column(
//                             children: [
//                               featuredButton(icon: featuredImages1[index], title: featuredTitles1[index]),
//                               10.heightBox,
//                               featuredButton(icon: featuredImages2[index], title: featuredTitles2[index]),
//                             ],
//                           ),
//                           ).toList(),
//                       ),
//                     ),
//
//                     // Featured Products section
//                     20.heightBox,
//                     Container(
//                       padding: EdgeInsets.all(12),
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: greenColor),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           featuredProduct.text.white.fontFamily(bold).size(18).make(),
//                           10.heightBox,
//                           SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: FutureBuilder(
//                               future: FirestoreServices.getFeaturedProducts(),
//                               builder: (context, AsyncSnapshot<QuerySnapshot>snapshot) {
//                                 if(snapshot.hasData){
//                                   return Center(
//                                     child: loadingIndicator(),
//                                   );
//                                 }
//                                 else if(snapshot.data!.docs.isEmpty){
//                                   return "No featured products".text.white.makeCentered();
//
//                                 }
//                                 else{
//                                   var featuredData = snapshot.data!.docs;
//
//                                 return Row(
//                                   children: List.generate(
//                                     featuredData.length,
//                                         (index) => Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Image.network(
//                                           featuredData[index]['p_images'][0],
//                                           width: 130,
//                                           height: 130,
//                                           fit: BoxFit.cover,
//                                       ),
//                                       10.heightBox,
//                                       "${featuredData[index]['p_name']}".text.size(16).fontFamily(semibold).color(darkFontGrey).make(),
//                                       10.heightBox,
//                                       "${featuredData[index]['p_price']}".numCurrency.text.size(16).fontFamily(semibold).color(greenColor).make(),
//                                     ],
//                                   ).box.white.margin(EdgeInsets.symmetric(horizontal: 4)).roundedSM.padding(EdgeInsets.all(8)).make(),)
//                                 );
//                                 }
//                               }
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//
//                     // Third swiper and other widgets...
//                     10.heightBox,
//                     VxSwiper.builder(
//                         aspectRatio: 16 / 9,
//                         autoPlay: true,
//                         height: 150,
//                         enlargeCenterPage: true,
//                         itemCount: secondSwiperList.length,
//                         itemBuilder: (context, index) {
//                           return Image.asset(
//                             secondSwiperList[index],
//                             fit: BoxFit.fill,
//                           ).box.rounded.clip(Clip.antiAlias).margin(const EdgeInsets.symmetric(horizontal: 8)).make();
//                         }),
//
//
//                     // StreamBuilder section
//                     10.heightBox,
//                     "All Products".text.fontFamily(semibold).color(darkFontGrey).size(16).align(TextAlign.start).make(),
//                     StreamBuilder(
//                       stream: FirestoreServices.allProducts(),
//                       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                         if (!snapshot.hasData) {
//                           return loadingIndicator();
//                         } else {
//                           var allProductsData = snapshot.data!.docs;
//                           return GridView.builder(
//                             physics: NeverScrollableScrollPhysics(),
//                             shrinkWrap: true,
//                             itemCount: allProductsData.length ,
//                             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 2,
//                               mainAxisSpacing: 8,
//                               crossAxisSpacing: 8,
//                               mainAxisExtent: 300,
//                             ),
//                             itemBuilder: (context, index) {
//                               return Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Image.network(
//                                     allProductsData[index]['p_images'][0],
//                                     width: 200,
//                                     height: 200,
//                                     fit: BoxFit.cover,
//                                   ),
//                                   Spacer(),
//                                   "${ allProductsData[index]['p_name']}".text.fontFamily(semibold).color(darkFontGrey).make(),
//                                   SizedBox(height: 10),
//                                   "${ allProductsData[index]['p_price']}".text.color(redColor).fontFamily(bold).size(16).make(),
//                                   10.heightBox,
//                                 ],
//                               ).box.white.margin(EdgeInsets.symmetric(horizontal: 4)).roundedSM.padding(EdgeInsets.all(12)).make()
//                               .onTap(() {
//                                 Get.to(() => ItemDetails(
//                                   title: "${allProductsData[index]['p_name']}",
//                                 data: allProductsData[index],));
//                               });
//                             },
//                           );
//                         }
//                       },
//                     ),
//
//                     // Ensure all widgets inside the SingleChildScrollView are properly closed
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
