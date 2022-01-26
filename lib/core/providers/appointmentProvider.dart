import 'package:flutter/material.dart';
import 'package:danaid/core/models/appointmentModel.dart';

class AppointmentModelProvider with ChangeNotifier {

  AppointmentModel? _appointment;

  AppointmentModelProvider(this._appointment);

  AppointmentModel? get getAppointment => _appointment;

  void setAppointmentModel(AppointmentModel val){
    _appointment = val;
    notifyListeners();
  }
  void setAdherentId(String val){
    _appointment?.adherentId = val;
    notifyListeners();
  }
  void setAnnouncement(bool val){
    _appointment?.announced = val;
    notifyListeners();
  }
  
}