import 'package:farmberry_project/consts/consts.dart';

class FirestoreServices {

  //get users data
  static getUser(uid) {
    return firestore.collection(usersCollection)
        .where('id', isEqualTo: uid)
        .snapshots();
  }

  //get products according to category
  static getProducts(category) {
    return firestore.collection(productCollection).where(
        'p_category', isEqualTo: category).snapshots();
  }

  //get products according to subcategory
  static getSubCategoryProduct(title) {
    return firestore.collection(productCollection).where(
        'p_subcategory', isEqualTo: title).snapshots();
  }


  //get cart
  static getCart(uid) {
    return firestore.collection(cartCollection).where(
        'added_by', isEqualTo: uid).snapshots();
  }

  //delete item
  static deleteDocument(docId) {
    return firestore.collection(cartCollection).doc(docId).delete();
  }

  //get all chat megs
  static getChatMessages(docId) {
    return firestore.collection(chatCollection).doc(docId).collection(
        messagesCollection).orderBy('created_on', descending: true).snapshots();
  }

  static getAllOrders() {
    return firestore.collection(ordersCollection).where(
        'order_by', isEqualTo: currentUser!.uid).snapshots();
  }

  static getWishlists() {
    return firestore.collection(productCollection).where(
        'p_wishlist', arrayContains: currentUser!.uid).snapshots();
  }

  static getAllMessages() {
    return firestore.collection(chatCollection).where(
        'fromId', isEqualTo: currentUser!.uid).snapshots();
  }

  static getCounts() async {
    var res = await Future.wait([
      firestore.collection(cartCollection).where('added_by', isEqualTo: currentUser!.uid).get().then((value) {
        return value.docs.length;
      }),
      firestore.collection(productCollection).where('p_wishlist', arrayContains: currentUser!.uid).get().then((value) {
        return value.docs.length;
      }),
      firestore.collection(ordersCollection).where('order_by', arrayContains: currentUser!.uid).get().then((value) {
        return value.docs.length;
      }),
    ]);
    return res;
  }

  static allProducts(){
    return firestore.collection(productCollection).snapshots();
  }
  
  static getFeaturedProducts(){
    return firestore.collection(productCollection).where('p_is_featured', isEqualTo: true).get();
  }

  static searchProducts(title) {
    return firestore.collection(productCollection).get();
  }

}


