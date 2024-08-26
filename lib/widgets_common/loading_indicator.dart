
import 'package:farmberry_project/consts/colors.dart';
import 'package:flutter/material.dart';

Widget loadingIndicator()
{
  return CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(greenColor)
  );
}