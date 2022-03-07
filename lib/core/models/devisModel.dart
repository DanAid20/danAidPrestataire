
import 'package:cloud_firestore/cloud_firestore.dart';

class DevisModel {
  
   String? id,appointementId, adherentId,beneficiaryId, paiementCode,consultationCode, prestataireEmitQuoteId, intitule, type ;
   num? amount;
   Timestamp? createdDate;
   bool? ispaid, isAdminHasTreatedRequest;
   List? requestTreatedList, urlImageDevis;
   int? status;
  DevisModel({this.id, this.appointementId, this.adherentId, this.beneficiaryId, this.paiementCode, this.consultationCode, this.prestataireEmitQuoteId, this.intitule, this.status, this.type, this.amount, this.createdDate, this.ispaid, this.isAdminHasTreatedRequest, this.urlImageDevis, this.requestTreatedList});

  factory DevisModel.fromDocument(DocumentSnapshot doc){
   
    return DevisModel(
      id: doc.id,
      prestataireEmitQuoteId: doc.get("prestataireId"),
      paiementCode: doc.get("PaiementCode"),
      appointementId: doc.get("appointementId"),
      requestTreatedList: doc.get("RequestTreatedList"),
      amount: doc.get("montant") != null ? double.parse(doc.get("montant").toString()) : null ,
      intitule: doc.get("intitule"),
      consultationCode: doc.get("consultationCode"),
      isAdminHasTreatedRequest: doc.get("isAdminHasTreatedRequest"),
      ispaid: doc.get("ispaid"),
      adherentId: doc.get("adherentId"),
      beneficiaryId: doc.get("beneficiaryId"),
      urlImageDevis: doc.get("urlImagesDevis"),
      type: doc.get("type"),
      status: doc.get("status"),
      createdDate: doc.get("createdDate"),
    );
  }

  getData(data){
    List.from(data).forEach((element){
         urlImageDevis?.add(element);
      });
    return urlImageDevis;
  }
}