class User {
  String createdDate;
  String emailAdress;
  bool enabled;
  String fullName;
  String imageUrl;
  String matricule;
  List<PhoneList> phoneList;
  String profil;
  String regionDorigione;
  String urlCNI;
  String userCountryCodeIso;
  String userCountryName;

  User(
      {this.createdDate,
        this.emailAdress,
        this.enabled,
        this.fullName,
        this.imageUrl,
        this.matricule,
        this.phoneList,
        this.profil,
        this.regionDorigione,
        this.urlCNI,
        this.userCountryCodeIso,
        this.userCountryName});

  User.fromJson(Map<String, dynamic> json) {
    createdDate = json['createdDate'];
    emailAdress = json['emailAdress'];
    enabled = json['enabled'];
    fullName = json['fullName'];
    imageUrl = json['imageUrl'];
    matricule = json['matricule'];
    if (json['phoneList'] != null) {
      phoneList = <PhoneList>[];
      json['phoneList'].forEach((v) {
        phoneList.add(new PhoneList.fromJson(v));
      });
    }
    profil = json['profil'];
    regionDorigione = json['regionDorigione'];
    urlCNI = json['urlCNI'];
    userCountryCodeIso = json['userCountryCodeIso'];
    userCountryName = json['userCountryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdDate'] = this.createdDate;
    data['emailAdress'] = this.emailAdress;
    data['enabled'] = this.enabled;
    data['fullName'] = this.fullName;
    data['imageUrl'] = this.imageUrl;
    data['matricule'] = this.matricule;
    if (this.phoneList != null) {
      data['phoneList'] = this.phoneList.map((v) => v.toJson()).toList();
    }
    data['profil'] = this.profil;
    data['regionDorigione'] = this.regionDorigione;
    data['urlCNI'] = this.urlCNI;
    data['userCountryCodeIso'] = this.userCountryCodeIso;
    data['userCountryName'] = this.userCountryName;
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
