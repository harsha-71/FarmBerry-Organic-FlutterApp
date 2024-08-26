import 'package:farmberry_project/consts/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget orderStatus({
  required IconData icon,
  required Color color,
  required String title,
  required bool showDone,
}) {
  return ListTile(
    leading: Icon(icon, color: color).box.roundedSM.padding(EdgeInsets.all(4)).border(color: color).make(),
    trailing: SizedBox(
      height: 100,
      width: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          title.text.color(darkFontGrey).make(),
          showDone
              ? Icon(
            Icons.done,
            color: greenColor,
          )
              : Container(),
        ],
      ),
    ),
  );
}
