import 'package:danaid/core/services/hiveDatabase.dart';
import 'package:danaid/language/Language_Helper.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LanguageProvider with ChangeNotifier {
  String currentLanguage;
  Locale locale;

  LanguageHelper languageHelper = LanguageHelper();
 
  Locale get getlocale => resuperLocalLang();

  Locale resuperLocalLang(){
    var box = Hive.box('language');
    String lang=box.get('language')!=null ? box.get('language'): null;
    var value=lang.contains("English") && lang!=null ? Locale('en', 'EN'):  lang.contains("Français") && lang!=null?Locale('fr', 'FR'): Locale('en', 'EN');
    this.locale=value;
    return value;
  }
  Locale theLang(){
    var box = Hive.box('language');
    String lang=box.get('language')!=null ? box.get('language'): null;
    var value=lang.contains("English") && lang!=null ? Locale('en', 'EN'):  lang.contains("Français") && lang!=null?Locale('fr', 'FR'): Locale('en', 'EN');
    this.locale=value;
    return value;
  }
  Future<void> changeLocale(String newLocale) async {
    Locale convertedLocale;
    print(newLocale);
    
    currentLanguage =  newLocale;

    convertedLocale = languageHelper.convertLangNameToLocale(newLocale);
    print(convertedLocale);
    await HiveDatabase.setLanguage(languageHelper.convertLocaleToLangName(newLocale));
    locale = convertedLocale;
    notifyListeners();
  }

  defineCurrentLanguage(context) {
    String definedCurrentLanguage;

    if (currentLanguage != null)
      definedCurrentLanguage = currentLanguage;
    else {
      print(
          "locale from currentData: ${Localizations.localeOf(context).toString()}");
      definedCurrentLanguage = languageHelper
          .convertLocaleToLangName(Localizations.localeOf(context).toString());
    }

    return definedCurrentLanguage;
  }
}