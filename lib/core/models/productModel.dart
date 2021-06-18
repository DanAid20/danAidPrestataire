import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String id, name, description, imgUrl;
  int points, qty;
  List imgGroup;

  ProductModel({this.id, this.name, this.description, this.imgUrl, this.points, this.qty, this.imgGroup});

  factory ProductModel.fromDocument(DocumentSnapshot doc){
    return ProductModel(
      id: doc.id,
      name: doc.data()["name"],
      description: doc.data()["description"],
      imgUrl: doc.data()["imageUrl"],
      points: doc.data()["points"],
      qty: doc.data()["quantity"],
      imgGroup: doc.data()["imageGroup"]
    );
  }
}