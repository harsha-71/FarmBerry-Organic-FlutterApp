import 'package:farmberry_project/consts/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../categories_screen/category_details.dart';

Widget featuredButton({String? title, icon})
{
  return Row(
    children: [
      Image.asset(icon, width: 60, fit: BoxFit.fill,),
      10.widthBox,
      title!.text.fontFamily(semibold).color(darkFontGrey).make(),
    ],
  )
      .box
      .width(200)
      .margin(EdgeInsets.symmetric(horizontal: 4))
      .white.padding(EdgeInsets.all(4))
      .roundedSM.roundedSM.outerShadowSm
      .make()
      .onTap(() {
    Get.to(() => CategoryDetails(title: title));
  })

  ;
}