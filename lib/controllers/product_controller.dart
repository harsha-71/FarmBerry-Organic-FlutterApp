import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmberry_project/consts/consts.dart';
import 'package:farmberry_project/views/chat_screen/controller/chat_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../consts/colors.dart';
import '../consts/styles.dart';
import '../models/category_model.dart';
import '../widgets_common/bg_widget.dart';
import 'package:get/get_core/src/get_main.dart';


class ProductController extends GetxController {

  var quantity = 0.obs;
  var colorIndex = 0.obs;
  var totalPrice = 0.obs;
  var subcat = [].obs; // Observable list for reactivity
  var isFav = false.obs;


  getSubCategories(title) async {
    try {
      var data = await rootBundle.loadString("lib/services/category_model.json");
      var decoded = categoryModelFromJson(data);
      var s = decoded.categories.where((element) => element.name == title).toList();

      subcat.value = s.isNotEmpty ? s[0].subcategories : []; // Update subcat with subcategories or empty list
      print('Fetched subcategories: ${subcat}'); // Optional logging
    } catch (error) {
      print('Error fetching subcategories: $error');
    }
  }

  changeColor(index){
    colorIndex.value = index;
  }

  increseQuantity(totalQuantity)
  {
    if(quantity.value < totalQuantity)
      {
        quantity.value++;
      }

  }

  decreseQuantity(){
    if(quantity.value > 0)
      {
        quantity.value--;

      }

  }

  calculateTotalPrice(price)
  {
    totalPrice.value = price * quantity.value;

  }

  addToCart({title, img,sellername, color,qty, tprice, context, vendorID}) async {
    await firestore.collection(cartCollection).doc().set({

      'title' : title,
      'img' : img,
      'sellername' : sellername,
      'color' : color,
      'qty' : qty,
      'vendor_id' : vendorID,
      'tprice' : tprice,
      'added_by' : currentUser!.uid
    }).catchError((error) {
      VxToast.show(context, msg: error.toString());
    });

  }

  resetValues() {
    totalPrice.value = 0;
    quantity.value = 0;
    colorIndex.value = 0;
  }

  addToWishList(docId, context) async{
    await firestore.collection(productCollection).doc(docId).set({
      'p_wishlist' : FieldValue.arrayUnion([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(true);
    VxToast.show(context, msg: "Added to wishlist");
  }

  removeWishList(docId, context) async{
    await firestore.collection(productCollection).doc(docId).set({
      'p_wishlist' : FieldValue.arrayRemove([currentUser!.uid])
    }, SetOptions(merge: true));

    isFav(false);
    VxToast.show(context, msg: "Removed from wishlist");
  }


  checkIsFav(data) async{
    if(data['p_wishlist'].contains(currentUser!.uid)){
      isFav(true);
    }
    else{
      isFav(false);
    }
  }



}

// ... CategoryDetails widget

Widget build(BuildContext context) {
  var controller = Get.find<ProductController>();

  var title;
  return bg_Widget(
      child: Scaffold(
        appBar: AppBar(
            title: title!.text.fontFamily(bold).make()
        ),
        body: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              if (controller.subcat.isEmpty)
                Text('No subcategories found for this category')
              else
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
                            .make()),
                  ),
                ),
              20.heightBox,
              // ... rest of the code for item container
            ],
          ),
        ),
      ));
}
