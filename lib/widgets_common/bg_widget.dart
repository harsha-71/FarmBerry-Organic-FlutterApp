import 'package:farmberry_project/consts/consts.dart';
import 'package:flutter/cupertino.dart';

Widget bg_Widget({Widget? child})
{
  return Container(
    decoration: const BoxDecoration(
      image: DecorationImage(image: AssetImage(imgBackground), fit: BoxFit.fill)),
    child: child,
  );
}