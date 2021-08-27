import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:securenotes/authentication/signup.dart';
import 'package:securenotes/models/notesmodel.dart';
import 'package:securenotes/models/notesprovider.dart';
import 'package:securenotes/screens/notesscreen.dart';
import 'package:securenotes/utils/firebasecollections.dart';
import 'package:securenotes/utils/global.dart';
import 'package:securenotes/utils/sharedpref.dart';
FirebaseAuth auth=FirebaseAuth.instance;

class UserAuthentication extends StatefulWidget {
  UserAuthentication({Key? key}) : super(key: key);

  @override
  _UserAuthenticationState createState() => _UserAuthenticationState();
}

class _UserAuthenticationState extends State<UserAuthentication> {
  TextEditingController emailcontroller=TextEditingController();
  TextEditingController passwordcontroller=TextEditingController();
   List<NoteModel> notelist=[];
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text("User Authentication",style: textStyle.copyWith(fontWeight: FontWeight.bold,fontSize: 18)),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 40),
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Email",style: textStyle.copyWith(fontWeight: FontWeight.bold,fontSize: 15),),
           
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: TextFormField(
                controller: emailcontroller,
                decoration: InputDecoration(
                  hintText: "Please enter your email",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: textcolor,width: 1)
                  ),
                  focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: textcolor,width: 1.5)
                  ),
                ),
              ),
            ),
            Text("Password",style: textStyle.copyWith(fontWeight: FontWeight.bold,fontSize: 15),),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: TextFormField(
                controller: passwordcontroller,
                decoration: InputDecoration(
                  hintText: "Please enter your password",
                  enabledBorder:OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: textcolor,width: 1)
                  ),
                  focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: textcolor,width: 1.5)
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: textcolor,padding: EdgeInsets.symmetric(horizontal: 30,vertical: 5)),
                onPressed: (){
                  
                 if(checkvalidity()){
                   loginuser();
                   }
              }, child: Text("Login")
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Didn't have an account? ",style: textStyle,),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>UserSignUp()));
                  },
                  child: Text("Sign Up",style: textStyle.copyWith(fontWeight: FontWeight.bold),),

                )
              ],
            )
          ],
        ),
      )
    );
  }
  bool checkvalidity(){
    if(emailcontroller.text.isEmpty){
      showsnackbar(context: context,title:"Please enter your email" );
     
      return false;
    }
   else if(passwordcontroller.text.isEmpty){
     showsnackbar(context: context,title:"Please enter your password" );
    
      return false;
    }
    else{
      return true;
    }
  }

  loginuser()async{
    if(emailcontroller.text.isNotEmpty&&passwordcontroller.text.isNotEmpty){
  await auth.signInWithEmailAndPassword(email: emailcontroller.text, password: passwordcontroller.text).then((value) {
    if(value.user!=null){
        SharedPref.preferences.setString("uid", value.user?.uid??"");
        showsnackbar(context: context,title:"Welcome ${value.user?.email} to the SecureNotes" );
        notescollection.doc(auth.currentUser?.uid).collection("usernotes").get().then((value) {
         notelist=value.docs.map((e) => NoteModel.fromMap(doc:e.data())).toList();
        Provider.of<NoteListProvider>(context,listen: false).updatelist(listofnotes:notelist );
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>NotesSection()), (route) => false);
        });
    
    }
  }).catchError((error){
    if(error.code=="invalid-email"){
      showsnackbar(context: context,title: "Please enter a valid email");
    
    }
    else if(error.code=="user-not-found"){
      showsnackbar(context: context,title:"User not found" );
   
    }
    else if(error.code=="wrong-password"){
      showsnackbar(context: context,title: "Please enter a valid password");
    
    }
    else{
      showsnackbar(context:context,title: error.code);
     
    }
  });

      
  //      UserCredential userCredential=await auth.signInWithEmailAndPassword(email: emailcontroller.text, password:passwordcontroller.text);
  //  print(userCredential.user?.uid);
    }
    else{
      print("field are empty");
    }
  

  }
}