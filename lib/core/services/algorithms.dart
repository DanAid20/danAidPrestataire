import 'dart:math';

import 'package:intl/intl.dart';

class Algorithms {
  String getMatricule(DateTime date,String region, String gender){
    random(min, max){
      var rn = new Random();
      return min + rn.nextInt(max - min);
    }
    
    T getRandomElement<T>(List<T> list) {
      final random = new Random();
      var i = random.nextInt(list.length);
      return list[i];
    }
    String getOneDigit(String gender){
      var list1 = ['1','3','5','7','9'];
      var list2 = ['2', '4', '6', '8'];
      return (gender == "F") ? getRandomElement(list1) : getRandomElement(list2);
    }
    //My Date
    String dateUnit = date.day.toString().padLeft(2, '0') + date.month.toString().padLeft(2, '0') + date.year.toString();
    //My Region First Letter
    String regionLetter = region[0].toUpperCase();
    //My Three digits
    String threeDigit = random(100,999).toString();
    //My One digit
    String oneDigit = getOneDigit(gender);

    return dateUnit+'-'+regionLetter+threeDigit+oneDigit;
  }
  
  static double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 + 
          c(lat1 * p) * c(lat2 * p) * 
          (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }
  static List<String> getTownNamesFromRegion(List origin, String region){
    List<String> target = [];
    for(int i=0; i<origin.length; i++){
      if (origin[i]["state_code"] == region){
       target.add(origin[i]["value"].toString());
      }
    }
    //print(target);
    return target;
  }
  static String getRegionFromStateCode(List origin, String code){
    String region;
    for(int i=0; i<origin.length; i++){
      if (origin[i]["key"] == code){
       region = origin[i]["value"];
      }
    }
    return region;
  }
  static String getStateCodeFromRegion(List origin, String region){
    String code;
    for(int i=0; i<origin.length; i++){
      if (origin[i]["value"] == region){
       code = origin[i]["key"];
      }
    }
    return code;
  }
  static String getAppointmentTypeLabel(String val){
    return val == "consult-today" ? "Consultation" : val == "appointment" ? "Rendez-vous" : val == "emmergency" ? "Urgence"
      : "Rendez-vous";
  }

  static String getConsultationTypeLabel(String val){
    return val == "Cabinet" ? "En Cabinet" : val == "Video" ? "Télé-Consultation" : val == "Domicile" ? "A Domicile"
      : "Rendez-vous";
  }

  static String getAppointmentReasonLabel(String val){
    return val == "nouvelle-consultation" ? "Nouvelle Consultation" : val == "suivi" ? "Contrôle" : val == "referencement" ? "Référencement" : val == "resultat-examen" ? "Résultats d'examen"
      : "Rendez-vous";
  }

  static String getFormattedDate(DateTime date){
    return DateFormat('EEEE', 'fr_FR').format(date)+", "+ date.day.toString().padLeft(2, '0') + " "+DateFormat('MMMM', 'fr_FR').format(date)+" "+ date.year.toString() + ", "+ date.hour.toString().padLeft(2, '0') + ":" + date.minute.toString().padLeft(2, '0');
  }

  static List getKeyWords(String input) {
    List getKeys(String input) {
      var keyWords = new List.filled(input.length, "", growable: true);
      for (int i = 0; i < input.length; i++) {
        keyWords[i] = input.substring(0, i + 1).toLowerCase();
      }
      return keyWords;
    }

    List getKeysReversed(String input) {
      var keyWords = new List.filled(input.length, "", growable: true);
      for (int i = 0; i < input.length; i++) {
        keyWords[i] =
            input.substring(0, i + 1).toLowerCase().split('').reversed.join('');
      }
      return keyWords;
    }

    var results = [];
    String inputReversed = input.split('').reversed.join('');
    var words = input.toLowerCase().split(new RegExp('\\s+'));
    var wordsReversed = inputReversed.toLowerCase().split(new RegExp('\\s+'));

    for (int i = 0; i < words.length; i++) {
      results = results + getKeys(words[i]);
    }
    for (int i = 0; i < words.length; i++) {
      results = results + getKeysReversed(wordsReversed[i]);
    }

    results = results + getKeys(input);
    results = results.toSet().toList();

    print(results.toString());

    return results;
  }

  static String getConversationId({String userId, String targetId}) {
    
    String conversationId;
    if (userId.hashCode <= targetId.hashCode) {
      conversationId = "$userId-$targetId";
    } else {
      conversationId = "$targetId-$userId";
    }
    return conversationId;
  }

  static String getDateFromTimestamp(int timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('HH:mm a');
    var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    var diff = date.difference(now);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + 'DAY AGO';
      } else {
        time = diff.inDays.toString() + 'DAYS AGO';
      }
    }

    return time;
  }
}