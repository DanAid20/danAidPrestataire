import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String id, name, description, imgUrl;
  int points, qty;
  List imgGroup;

  ProductModel({this.id, this.name, this.description, this.imgUrl, this.points, this.qty, this.imgGroup});

  factory ProductModel.fromDocument(DocumentSnapshot doc){
    return ProductModel(
      id: doc.id,
      name: doc.get("name"),
      description: doc.get("description"),
      imgUrl: doc.get("imageUrl"),
      points: doc.get("points"),
      qty: doc.get("quantity"),
      imgGroup: doc.get("imageGroup")
    );
  }
}