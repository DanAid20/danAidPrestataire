import 'package:danaid/core/models/serviceProviderModel.dart';
import 'package:flutter/material.dart';

class ServiceProviderTileModelProvider with ChangeNotifier {
  ServiceProviderModel _serviceProvider;

  ServiceProviderTileModelProvider(this._serviceProvider);

  ServiceProviderModel get getServiceProvider => _serviceProvider;

  void setServiceProviderModel(ServiceProviderModel val){
    _serviceProvider = val;
    notifyListeners();
  }

  void setServiceProviderId(String val){
    _serviceProvider.id = val;
    notifyListeners();
  }

  void setName(String val){
    _serviceProvider.name = val;
    notifyListeners();
  }

  void setContactName(String val){
    _serviceProvider.contactName = val;
    notifyListeners();
  }

  void setContactEmail(String val){
    _serviceProvider.contactEmail = val;
    notifyListeners();
  }

  void setCategory(String val){
    _serviceProvider.category = val;
    notifyListeners();
  }
   void setAbout(String val){
    _serviceProvider.about = val;
    notifyListeners();
  }
  void setAvatarUrl(String val){
    _serviceProvider.avatarUrl = val;
    notifyListeners();
  }

  void setOtherDocUrl(String val){
    _serviceProvider.otherDocUrl = val;
    notifyListeners();
  }
  
   void setServiceList(Map val){
    _serviceProvider.serviceList = val;
    notifyListeners();
  }
  void setCniUrl(String val){
    _serviceProvider.cniUrl = val;
    notifyListeners();
  }

  void setOrderRegistrationCertificateUrl(String val){
    _serviceProvider.orderRegistrationCertificateUrl = val;
    notifyListeners();
  }

  void setTown(String val){
    _serviceProvider.town = val;
    notifyListeners();
  }

  void setRegion(String val){
    _serviceProvider.region = val;
    notifyListeners();
  }

  void setCountryName(String val){
    _serviceProvider.countryName = val;
    notifyListeners();
  }

  void setIsoCountryCode(String val){
    _serviceProvider.isoCountryCode = val;
    notifyListeners();
  }

  void setLocalisation(String val){
    _serviceProvider.localisation = val;
    notifyListeners();
  }
  void setcoordGps(Map val){
    _serviceProvider.coordGps = val;
    notifyListeners();
  }

  void setProfileEnableState(bool val){
    _serviceProvider.profileEnabled = val;
    notifyListeners();
  }

  void addNumber(String val){
    _serviceProvider.phoneList.add({"number": val});
    notifyListeners();
  }
}