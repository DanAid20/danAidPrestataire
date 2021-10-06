import 'package:cloud_firestore/cloud_firestore.dart';

class CampaignModel {
  String id, name, description, scope;
  bool active, requireCoupon;
  Timestamp startDate, endDate;
  List targetLevels;
  num amount;

  CampaignModel({this.id, this.name, this.description, this.active, this.requireCoupon, this.scope, this.startDate, this.endDate, this.targetLevels, this.amount});

  factory CampaignModel.fromDocument(DocumentSnapshot doc){
    return CampaignModel(
      id: doc.id,
      name: doc.data()['name'],
      description: doc.data()['description'],
      active: doc.data()['active'],
      requireCoupon: doc.data()['requireCoupon'],
      startDate: doc.data()['startDate'],
      endDate: doc.data()['endDate'],
      targetLevels: doc.data()['niveaux'],
      scope: doc.data()['reductionScope'],
      amount: doc.data()['amount'],
    );
  }
}