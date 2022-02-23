import 'package:cloud_firestore/cloud_firestore.dart';

class CampaignModel {
  String? id, name, description, scope;
  bool? active, requireCoupon;
  Timestamp? startDate, endDate;
  List? targetLevels;
  num? amount;

  CampaignModel({this.id, this.name, this.description, this.active, this.requireCoupon, this.scope, this.startDate, this.endDate, this.targetLevels, this.amount});

  factory CampaignModel.fromDocument(DocumentSnapshot doc, Map data){
    return CampaignModel(
      id: doc.id,
      name: data['name'],
      description: data['description'],
      active: data['active'],
      requireCoupon: data['requireCoupon'],
      startDate: data['startDate'],
      endDate: data['endDate'],
      targetLevels: data['niveaux'],
      scope: data['reductionScope'],
      amount: data['amount'],
    );
  }
}