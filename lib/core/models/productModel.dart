import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String? id, name, description, imgUrl;
  int? points, qty;
  List? imgGroup;

  ProductModel({this.id, this.name, this.description, this.imgUrl, this.points, this.qty, this.imgGroup});

  factory ProductModel.fromDocument(DocumentSnapshot doc, Map data){
    return ProductModel(
      id: doc.id,
      name: data["name"],
      description: data["description"],
      imgUrl: data["imageUrl"],
      points: data["points"],
      qty: data["quantity"],
      imgGroup: data["imageGroup"]
    );
  }
}