import 'package:farmberry_project/consts/consts.dart';
import 'package:flutter/cupertino.dart';

Widget detailCart({width, String? count, String? title})
{
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      count!.text.fontFamily(bold).color(darkFontGrey).size(16).make(),
      5.heightBox,
      title!.text.color(darkFontGrey).make(),
    ],
  ).box.white.rounded.width(width).height(80).padding(EdgeInsets.all(4)).make();

}