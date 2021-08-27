

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:securenotes/models/notesmodel.dart';
import 'package:securenotes/models/notesprovider.dart';
import 'package:securenotes/screens/splashscreen.dart';
import 'package:securenotes/utils/firebasecollections.dart';
import 'package:securenotes/utils/sharedpref.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() async{
 WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPref.preferences=await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
 
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   NoteListProvider noteListProvider=NoteListProvider(noteslist: []);
  @override
  void initState() { 
    super.initState();
    getnoteslist();
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NoteListProvider>(create: (context)=>noteListProvider),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
  
Future<void> getnoteslist()async{
  String uid=SharedPref.getString(key: "uid");
  print("uid:$uid");
  if(uid.isNotEmpty){
    Future<List<NoteModel>> noteslist=notescollection.doc(uid).collection("usernotes").get().then((value) {
   if(value.docs.isEmpty){
     return [];
   }
   else{
      return value.docs.map((e) => NoteModel.fromMap(doc: e.data())).toList();
   }
    
  });
  noteListProvider=NoteListProvider(noteslist:await noteslist);
  }
 
  }
}
