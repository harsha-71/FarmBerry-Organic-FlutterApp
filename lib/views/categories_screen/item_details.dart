import 'package:farmberry_project/consts/colors.dart';
import 'package:farmberry_project/consts/consts.dart';
import 'package:farmberry_project/consts/lists.dart';
import 'package:farmberry_project/controllers/product_controller.dart';
import 'package:farmberry_project/views/chat_screen/chat_screen.dart';
import 'package:farmberry_project/widgets_common/our_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemDetails extends StatelessWidget {
  final String? title;
  final dynamic data;
  const ItemDetails({super.key, required this.title, this.data});

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(ProductController());
    return WillPopScope(
      onWillPop: () async{
        controller.resetValues();
        return true;
      },
      child: Scaffold(

        appBar: AppBar(
          leading:  IconButton(
            onPressed: () {
              controller.resetValues();
              Get.back();
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: title!.text.color(darkFontGrey).fontFamily(semibold).make(),
          actions: [
            IconButton(onPressed: () {},
                icon: Icon(
                  Icons.share,
                  color: darkFontGrey,
                )),
            Obx(
                () => IconButton(onPressed: () {
                if(controller.isFav.value){
                  controller.removeWishList(data.id, context);

                }else{
                  controller.addToWishList(data.id, context);

                }
              },
                  icon: Icon(
                    Icons.favorite_outlined,
                    color: controller.isFav.value ? greenColor:darkFontGrey,
                  )),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: Padding(
              padding: EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //swiper section

                    VxSwiper.builder(
                      autoPlay: true,
                        height: 350,
                        itemCount: data['p_images'].length,
                        aspectRatio: 16/9,
                        viewportFraction: 1.0,
                        itemBuilder: (context,index) {
                        return Image.network(
                        data["p_images"][index],
                        width: double.infinity,
                        fit: BoxFit.cover,
                        );
                        }),

                    10.heightBox,
                    //rating and details section
                    title!.text.size(16).color(darkFontGrey).fontFamily(bold).make(),
                    //rating
                    10.heightBox,
                    VxRating(
                      value: double.parse(data["p_rating"]),
                        isSelectable: false,
                        onRatingUpdate: (value){},
                        normalColor: textfieldGrey,
                        selectionColor: golden,
                        count: 5,
                      maxRating: 5,
                        size: 25,
                    ),


                    10.heightBox,
                    "${data["p_price"]}".numCurrency.text.color(redColor).fontFamily(bold).size(18).make(),

                    10.heightBox,
                    Row(
                      children: [
                        Expanded(
                    child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Seller".text.white.fontFamily(semibold).make(),
                            5.heightBox,
                            "${data["p_seller"]}".text.white.color(darkFontGrey).fontFamily(semibold).size(16).make(),


                          ],
                        )),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.message_rounded,color: darkFontGrey)
                        ).onTap(() {
                          Get.to(() => chatScreen(),
                          arguments: [data['p_seller'], data['vendor_id']],
                          );
                        })
                      ],
                    ).box.height(60
                    ).padding(EdgeInsets.symmetric(horizontal: 16)).color(textfieldGrey).make(),

                    //color section
                    20.heightBox,
                    Obx(
                      () => Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: "Color:".text.color(textfieldGrey).make(),
                              ),

                              Row(
                                children:
                                  List.generate(
                                          data["p_colors"].length,
                                          (index) => Stack(
                                            alignment: Alignment.center,
                                            children:[
                                              VxBox().
                                              size(40, 40)
                                                  .roundedFull
                                                  .color(Color(data["p_colors"][index]).withOpacity(1.0))
                                            .margin(EdgeInsets.symmetric(horizontal: 4)).make().onTap(() {

                                              controller.changeColor(index);

                                              }),

                                            Visibility(
                                              visible: index == controller.colorIndex.value,
                                              child: Icon(Icons.done, color: Colors.white),)

                                          ],
                                          ),
                                  )
                              )
                            ],
                          ).box.padding(EdgeInsets.all(8)).make(),

                          //quantity row
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: "Quantity:".text.color(textfieldGrey).make(),
                              ),

                              Obx(
                                  () => Row(
                                  children: [

                                    IconButton(onPressed:() {
                                      controller.decreseQuantity();
                                      controller.calculateTotalPrice(int.parse(data["p_quatity"]));
                                      }, icon: Icon(Icons.remove)),
                                    controller.quantity.value.text.size(16).color(darkFontGrey).fontFamily(bold).make(),


                                    IconButton(onPressed:() {
                                      controller.increseQuantity(int.parse(data["p_quatity"]));
                                      controller.calculateTotalPrice(int.parse(data["p_price"]));
                                    }, icon: Icon(Icons.add)),
                                    10.widthBox,
                                    "(${data["p_quatity"]} availabel)".text.color(darkFontGrey).make(),
                                  ],
                                ),
                              ),
                        ],

                      ).box.padding(EdgeInsets.all(8)).make(),

                          //total row
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: "Total Price:".text.color(textfieldGrey).make(),
                              ),
                              "${controller.totalPrice.value}".numCurrency.text.color(redColor).size(16).fontFamily(bold).make(),

                            ],

                          ).box.padding(EdgeInsets.all(8)).make(),


                          //description section
                          "Description".text.color(darkFontGrey).fontFamily(semibold).make(),
                          10.heightBox,
                          "${data["p_desc"]}".text.color(darkFontGrey).make(),

                          10.heightBox,
                          //button section
                          ListView(
                            shrinkWrap:true,
                            children: List.generate(
                                     itemDetailsButtonList.length,
                                    (index) => ListTile(
                              title: itemDetailsButtonList[index].text.fontFamily(semibold).color(darkFontGrey).make(),
                              trailing: Icon(Icons.arrow_forward),

                            )),
                          ),

                           20.heightBox,
                          //products you may like section
                          productyoumaylike.text.fontFamily(bold).size(16).color(darkFontGrey).align(TextAlign.left).make(),
                          10.heightBox,
                                    SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                      children:
                      List.generate(6,
                              (index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(imgP1, width: 150, fit: BoxFit.cover,
                              ),
                              10.heightBox,
                              "Laptop 4GB/64GB".text.fontFamily(semibold).color(darkFontGrey).make(),
                              10.heightBox,
                              "\$600".text.color(redColor).fontFamily(bold).size(16).make()
                            ],


                          ).box.white.margin(EdgeInsets.symmetric(horizontal: 4)).roundedSM.padding(EdgeInsets.all(8)).make())
                                    ),
                                  ),
                          //here our details screen is done!

                                      ],
                      ).box.white.shadowSm.make(),
                    ),
                ],
              ),
            )
            )),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ourButton(
                color: greenColor, onPress: (){
                  if(controller.quantity.value > 0)
                    {
                      controller.addToCart(
                          color: data['p_colors'][controller.colorIndex.value],
                          context: context,
                          vendorID: data['vendor_id'],
                          img: data['p_images'][0],
                          qty: controller.quantity.value,
                          sellername: data['p_seller'],
                          title: data['p_name'],
                          tprice: controller.totalPrice.value
                      );
                      VxToast.show(context, msg: "Added to cart!");
                    }
                  else{
                    VxToast.show(context, msg: "Quantity can't be 0!");
                  }
              }, textColor: whiteColor, title: "Add to Cart"
              ),
            )
          ],

        ),

      ),
    );
  }
}
