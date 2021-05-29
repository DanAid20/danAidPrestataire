import 'package:cloud_firestore/cloud_firestore.dart';

class Facture {
  
  final String types, id, idAdherent, idBeneficiairy, idFammillyMember, idMedecin;
  final int amountToPay, canPay;
  final bool isSolve;
  final DateTime createdAt;

  Facture({this.amountToPay, this.canPay, this.createdAt, this.id, this.idAdherent, this.idBeneficiairy, this.idFammillyMember, this.idMedecin, this.isSolve, this.types});

  factory Facture.fromDocument(DocumentSnapshot doc){
     Timestamp t = doc.data()["createdAt"];
    DateTime date = t.toDate();

    return Facture(
      id: doc.data()["id"],
      types: doc.data()["Type"],
      idAdherent: doc.data()["idAdherent"],
      idBeneficiairy: doc.data()["idBeneficiairy"],
      idFammillyMember: doc.data()["idFammillyMember"],
      idMedecin: doc.data()["idMedecin"],
      amountToPay: doc.data()["amountToPay"],
      canPay: doc.data()["canPay"],
      isSolve: doc.data()["isSolve"],
      createdAt:date,
    );
  }

}