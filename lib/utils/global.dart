import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

TextStyle textStyle=TextStyle(color: Color(0xff27335E),fontSize: 14);

PreferredSizeWidget customAppBar({String titlename=""}){
  return AppBar(
    leading: SizedBox.shrink(),
    leadingWidth: 0,
    elevation: 1,
    title: Text(titlename,style: textStyle.copyWith(color: textcolor,fontWeight: FontWeight.bold,fontSize: 18),),
    backgroundColor: Colors.white,
  );
}

Color textcolor= Color(0xff27335E);

String dateformatter(DateTime dateTime){
  return DateFormat("MMM dd,y").add_jm().format(dateTime);
}

void showsnackbar({BuildContext? context,String title=""}){
        ScaffoldMessenger.of(context!).showSnackBar(SnackBar(content: Text(title),duration: Duration(milliseconds: 500),));
}