import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Preferences{
  SharedPreferences preference;
  getInit() async{
    preference = await SharedPreferences.getInstance();
  }
}
Preferences preferences = Preferences();
final kbackground = Color(0xFFFFFFFF);
final kforeground = Color(0xFFf4BC59);
final fieldColor = Color(0xFFFFFFFF);
final kmargin = 2.0;
final kpadding = 2.0;
final textcolor = Colors.white;
final iconcolor = Colors.white;
final iconColor = Colors.black.withOpacity(0.8);
final productColor = Color(0xFFFE724C);
final backgroundProduct = Color(0xFFF7F7F7);