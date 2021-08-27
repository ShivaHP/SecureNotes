import 'package:shared_preferences/shared_preferences.dart';

class SharedPref{
 static late SharedPreferences preferences;
 static String getString({String key=""}){
    return preferences.getString(key)??"";
  }
}