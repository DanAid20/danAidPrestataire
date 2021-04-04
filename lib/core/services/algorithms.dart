import 'dart:math';

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
}