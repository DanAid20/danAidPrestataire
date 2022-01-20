import 'package:cloud_firestore/cloud_firestore.dart';

class CampaignModel {
  String? id, name, description, scope;
  bool? active, requireCoupon;
  Timestamp? startDate, endDate;
  List? targetLevels;
  num? amount;

  CampaignModel({this.id, this.name, this.description, this.active, this.requireCoupon, this.scope, this.startDate, this.endDate, this.targetLevels, this.amount});

  factory CampaignModel.fromDocument(DocumentSnapshot doc){
    return CampaignModel(
      id: doc.id,
      name: doc.get('name'),
      description: doc.get('description'),
      active: doc.get('active'),
      requireCoupon: doc.get('requireCoupon'),
      startDate: doc.get('startDate'),
      endDate: doc.get('endDate'),
      targetLevels: doc.get('niveaux'),
      scope: doc.get('reductionScope'),
      amount: doc.get('amount'),
    );
  }
}