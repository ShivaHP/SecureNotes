import 'package:flutter/material.dart';
import 'package:securenotes/authentication/authentication.dart';
import 'package:securenotes/utils/global.dart';
import 'package:securenotes/utils/sharedpref.dart';

import 'notesscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() { 
    super.initState();
  String uid= SharedPref.getString(key: "uid");
  print("uidinsplash:$uid");
    Future.delayed(Duration(milliseconds: 1800),(){
      if(uid.isNotEmpty){
        print("Uid:$uid");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NotesSection()));
      }
      else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UserAuthentication() ));
      }
    
    });

 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Text("Welcome to the app, Ready for your todo",style: textStyle.copyWith(fontWeight: FontWeight.bold,fontSize: 16),),
      ),
    );
  }
}