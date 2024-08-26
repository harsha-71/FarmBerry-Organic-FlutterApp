import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmberry_project/consts/consts.dart';
import 'package:farmberry_project/controllers/product_controller.dart';
import 'package:farmberry_project/services/firestore_services.dart';
import 'package:farmberry_project/views/categories_screen/item_details.dart';
import 'package:farmberry_project/widgets_common/bg_widget.dart';
import 'package:farmberry_project/widgets_common/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CategoryDetails extends StatefulWidget {
  final String title;

  const CategoryDetails({super.key, required this.title});

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {

  @override
  void initState()
  {
    super.initState();
    switchCategory(widget.title);
  }

  switchCategory(title){
    if(controller.subcat.contains(title))
      {
        productMethod = FirestoreServices.getSubCategoryProduct(title);
      }
    else{
      productMethod = FirestoreServices.getProducts(title);
    }
  }

  var controller = Get.find<ProductController>();
  dynamic productMethod;

  @override
  Widget build(BuildContext context) {



    return bg_Widget(
      child: Scaffold(
        appBar: AppBar(
          title: widget.title!.text.fontFamily(bold).make()
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                    controller.subcat.length,
                        (index) => "${controller.subcat[index]}".text
                        .fontFamily(semibold)
                        .color(darkFontGrey)
                        .makeCentered()
                        .box
                        .white
                        .rounded
                        .size(120, 60)
                        .margin(EdgeInsets.symmetric(horizontal: 4))
                        .make().onTap(() {
                          switchCategory("${controller.subcat[index]}");
                          setState(() {

                          });
                        })),
              ),
            ),
            20.heightBox,
            StreamBuilder(
              stream:productMethod,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(!snapshot.hasData){
                  return Expanded(
                    child: Center(
                      child: loadingIndicator(),
                    ),
                  );
                }
                else if(snapshot.data!.docs.isEmpty){
                  return Expanded(
                    child: "No products found!".text.color(darkFontGrey).makeCentered(),
                  );
                }
                else{
                  var data = snapshot.data!.docs;

                  return
                        Expanded(child: GridView.builder(

                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisExtent: 250, mainAxisSpacing: 8, crossAxisSpacing: 8), itemBuilder:(context, index){


                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                data[index]['p_images'][0],
                                width: 230,
                                height: 160,
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.error), // Display an error icon if image fails to load
                              ),

                              "${data[index]['p_name']}".text.fontFamily(semibold).color(darkFontGrey).make(),
                              10.heightBox,
                              "${data[index]['p_price']}".numCurrency.text.color(redColor).fontFamily(bold).size(16).make(),
                              10.heightBox,

                                                      ],

                          ).box.white.margin(EdgeInsets.symmetric(horizontal: 20)).roundedSM.padding(EdgeInsets.all(12)).make().onTap(() {
                            controller.checkIsFav(data[index]);
                            Get.to(
                                    () => ItemDetails(
                                      title: "${data[index]['p_name']}",
                                      data: data[index],
                                    ));
                          });
                        }));
                }
            }
            ),
          ],
        )
      ));
  }
}
