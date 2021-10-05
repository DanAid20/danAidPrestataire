
import 'package:cloud_firestore/cloud_firestore.dart';

class DevisModel {
  
   String id,appointementId, adherentId,beneficiaryId, paiementCode,consultationCode, prestataireEmitQuoteId, intitule, type ;
   num amount;
   Timestamp createdDate;
   bool ispaid, isAdminHasTreatedRequest;
   List requestTreatedList, urlImageDevis;
   int status;
  DevisModel({this.id, this.appointementId, this.adherentId, this.beneficiaryId, this.paiementCode, this.consultationCode, this.prestataireEmitQuoteId, this.intitule, this.status, this.type, this.amount, this.createdDate, this.ispaid, this.isAdminHasTreatedRequest, this.urlImageDevis, this.requestTreatedList});

  factory DevisModel.fromDocument(DocumentSnapshot doc){
    print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    print(doc.data()["urlImagesDevis"].runtimeType);
    print(doc.data()["urlImagesDevis"].length);
    return DevisModel(
      id: doc.id,
      prestataireEmitQuoteId: doc.data()["prestataireId"],
      paiementCode: doc.data()["PaiementCode"],
      appointementId: doc.data()["appointementId"],
      requestTreatedList: doc.data()["RequestTreatedList"],
      amount: doc.data()["montant"] != null ? double.parse(doc.data()["montant"].toString()) : null ,
      intitule: doc.data()["intitule"],
      consultationCode: doc.data()["consultationCode"],
      isAdminHasTreatedRequest: doc.data()["isAdminHasTreatedRequest"],
      ispaid: doc.data()["ispaid"],
      adherentId: doc.data()["adherentId"],
      beneficiaryId: doc.data()["beneficiaryId"],
      urlImageDevis: doc.data()["urlImagesDevis"],
      type: doc.data()["type"],
      status: doc.data()["status"],
      createdDate: doc.data()["createdDate"],
    );
  }

  getData(data){
    List.from(data).forEach((element){
         urlImageDevis.add(element);
      });
    return urlImageDevis;
  }
}