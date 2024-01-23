import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String? product_title;
  String? type;
  String? price;
  String? ImageURLs;
  String? description;
  String? email;
  String? uid;
  String? P_id;

  ProductModel({
    this.product_title,
    this.type,
    this.price,
    this.ImageURLs,
    this.description,
    this.uid,
    this.P_id,
    this.email,
  });

  ProductModel.fromMap(Map<String, dynamic> map) {
    product_title = map["product_title"];
    type = map["type"];
    price = map["price"];
    email = map["email"];
    ImageURLs = map["image"];
    description = map["description"];
    uid = map["uid"];
    P_id = map["P_id"];
  }

  Map<String, dynamic> toMap() {
    return {
      "product_title": product_title,
      "type": type,
      "price": price,
      "email": email,
      "description": description,
      "image": ImageURLs,
      "uid": uid,
      "P_id": P_id,
    };
  }

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    return ProductModel(
      product_title: data?["product_title"],
      type: data?["type"],
      price: data?["price"],
      email: data?["email"],
      ImageURLs: data?["image"],
      description: data?["description"],
      uid: data?["uid"],
      P_id: data?["P_id"],
    );
  }
}
