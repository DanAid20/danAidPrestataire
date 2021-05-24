import 'package:cloud_firestore/cloud_firestore.dart';

class UseCaseModel {
  String id, adherentId, consultationCode, beneficiaryId, doctorId, beneficiaryName, establishment, otherInfo, title, type;
  Timestamp dateCreated;
  double amount;
  int status;

  UseCaseModel({this.id, this.adherentId, this.doctorId, this.consultationCode, this.beneficiaryId, this.beneficiaryName, this.amount, this.establishment, this.otherInfo, this.title, this.type, this.dateCreated, this.status});

  factory UseCaseModel.fromDocument(DocumentSnapshot doc){
    return UseCaseModel(
      id: doc.id,
      adherentId: doc.data()["adherentId"],
      beneficiaryId: doc.data()["beneficiaryId"],
      beneficiaryName: doc.data()["beneficiaryName"],
      consultationCode: doc.data()["consultationCode"],
      status: doc.data()["status"],
      doctorId: doc.data()["doctorId"],
      title: doc.data()["title"],
      amount: doc.data()["amountToPay"] != null ? double.parse(doc.data()["amountToPay"].toString()) : null,
      establishment: doc.data()["establishment"],
      otherInfo: doc.data()["otherInfo"],
      type: doc.data()["type"],
      dateCreated: doc.data()["createdDate"],
    );
  }
}