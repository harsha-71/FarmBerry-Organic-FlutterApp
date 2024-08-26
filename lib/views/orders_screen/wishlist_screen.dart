import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:farmberry_project/consts/consts.dart';
import '../../services/firestore_services.dart';
import '../../widgets_common/loading_indicator.dart';

class WishListScreen extends StatelessWidget {
  const WishListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "My Wishlist".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreServices.getWishlists(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: "No wishlists yet!".text.color(darkFontGrey).makeCentered(),
            );
          } else {
            var data = snapshot.data!.docs;
            return ListView.builder(
          itemCount: data.length, itemBuilder: (BuildContext context, int index){
          return ListTile(
          leading: Image.network(
            '${data[index]['p_images'][0]}',
            width: 80,
            fit: BoxFit.cover,),
            title: "${data[index]['p_name']}".text.fontFamily(semibold).color(darkFontGrey).make(),
             subtitle: "${data[index]['p_price']}".numCurrency.text.fontFamily(semibold).color(redColor).make(),
            trailing: Icon(
                Icons.favorite,
                color: redColor)
                .onTap(() {
                  
                  firestore.collection(productCollection).doc(data[index].id).set({
                    'p_wishlist' : FieldValue.arrayRemove([currentUser!.uid]),
                  },
                  SetOptions(merge: true));


            }),
         );
     },
      );


          }
        },
      ),
    );
  }
}
