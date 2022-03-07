import 'package:cloud_firestore/cloud_firestore.dart';

class Facture {
  
  final String? types, id, idAdherent, idBeneficiairy, idFammillyMember, idMedecin;
  final int? amountToPay, canPay;
  final bool? isSolve;
  final DateTime? createdAt;

  Facture({this.amountToPay, this.canPay, this.createdAt, this.id, this.idAdherent, this.idBeneficiairy, this.idFammillyMember, this.idMedecin, this.isSolve, this.types});

  factory Facture.fromDocument(DocumentSnapshot doc){
     Timestamp t = doc.get("createdAt");
    DateTime date = t.toDate();
    print(doc.data().toString());
    return Facture(
      id: doc.get("id"),
      types: doc.get("Type"),
      idAdherent: doc.get("idAdherent"),
      idBeneficiairy: doc.get("idBeneficiairy"),
      idFammillyMember: doc.data().toString().contains('idFammillyMember') ? doc.get('idFammillyMember') : '',
      idMedecin: doc.get("idMedecin"),
      amountToPay: doc.get("amountToPay"),
      canPay: doc.data().toString().contains('canPay')? doc.get('canPay') : 0,
      isSolve: doc.get("isSolve"),
      createdAt:date,
    );
  }

}