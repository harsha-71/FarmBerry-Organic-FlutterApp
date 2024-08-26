import 'package:farmberry_project/consts/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HomeController extends GetxController{

  @override
  void onInit()
  {
    getUserName();
    super.onInit();
  }

  var currentNavIndex = 0.obs;
  var username = '';
  var featureList = [];
  var searchController = TextEditingController();

  getUserName() async{

    var n = await firestore.collection(usersCollection).where('id', isEqualTo: currentUser!.uid).get().then((value){
      if(value.docs.isEmpty){
        return value.docs.single['name'];
      }
    });

    username = n;


  }
}