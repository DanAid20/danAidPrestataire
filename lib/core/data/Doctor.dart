class Doctor {
  String categorieEtablissement;
  String certificatDenregistrmDordre;
  String cniName;
  String communeHospital;
  String domaine;
  String email;
  String id;
  String nomDefamille;
  String nomEtablissement;
  String personneContactName;
  String personneContactPhone;
  List<PhoneList> phoneList;
  String prenom;
  String profil;
  bool profilEnanble;
  String serviceMedcin;
  String sexe;
  String specialite;
  String urlImage;
  String urlScaneCNI;
  String urlScaneCertificatEnregDordr;
  String ville;

  Doctor(
      {this.categorieEtablissement,
        this.certificatDenregistrmDordre,
        this.cniName,
        this.communeHospital,
        this.domaine,
        this.email,
        this.id,
        this.nomDefamille,
        this.nomEtablissement,
        this.personneContactName,
        this.personneContactPhone,
        this.phoneList,
        this.prenom,
        this.profil,
        this.profilEnanble,
        this.serviceMedcin,
        this.sexe,
        this.specialite,
        this.urlImage,
        this.urlScaneCNI,
        this.urlScaneCertificatEnregDordr,
        this.ville});

  Doctor.fromJson(Map<String, dynamic> json) {
    categorieEtablissement = json['categorieEtablissement'];
    certificatDenregistrmDordre = json['certificatDenregistrmDordre'];
    cniName = json['cniName'];
    communeHospital = json['communeHospital'];
    domaine = json['domaine'];
    email = json['email'];
    id = json['id'];
    nomDefamille = json['nomDefamille'];
    nomEtablissement = json['nomEtablissement'];
    personneContactName = json['personneContactName'];
    personneContactPhone = json['personneContactPhone'];
    if (json['phoneList'] != null) {
      phoneList = <PhoneList>[];
      json['phoneList'].forEach((v) {
        phoneList.add(new PhoneList.fromJson(v));
      });
    }
    prenom = json['prenom'];
    profil = json['profil'];
    profilEnanble = json['profilEnanble'];
    serviceMedcin = json['serviceMedcin'];
    sexe = json['sexe'];
    specialite = json['specialite'];
    urlImage = json['urlImage'];
    urlScaneCNI = json['urlScaneCNI'];
    urlScaneCertificatEnregDordr = json['urlScaneCertificatEnregDordr'];
    ville = json['ville'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categorieEtablissement'] = this.categorieEtablissement;
    data['certificatDenregistrmDordre'] = this.certificatDenregistrmDordre;
    data['cniName'] = this.cniName;
    data['communeHospital'] = this.communeHospital;
    data['domaine'] = this.domaine;
    data['email'] = this.email;
    data['id'] = this.id;
    data['nomDefamille'] = this.nomDefamille;
    data['nomEtablissement'] = this.nomEtablissement;
    data['personneContactName'] = this.personneContactName;
    data['personneContactPhone'] = this.personneContactPhone;
    if (this.phoneList != null) {
      data['phoneList'] = this.phoneList.map((v) => v.toJson()).toList();
    }
    data['prenom'] = this.prenom;
    data['profil'] = this.profil;
    data['profilEnanble'] = this.profilEnanble;
    data['serviceMedcin'] = this.serviceMedcin;
    data['sexe'] = this.sexe;
    data['specialite'] = this.specialite;
    data['urlImage'] = this.urlImage;
    data['urlScaneCNI'] = this.urlScaneCNI;
    data['urlScaneCertificatEnregDordr'] = this.urlScaneCertificatEnregDordr;
    data['ville'] = this.ville;
    return data;
  }
}

class PhoneList {
  String number;
  String operator;
  bool receptionPayement;

  PhoneList({this.number, this.operator, this.receptionPayement});

  PhoneList.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    operator = json['operator'];
    receptionPayement = json['receptionPayement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['operator'] = this.operator;
    data['receptionPayement'] = this.receptionPayement;
    return data;
  }
}
