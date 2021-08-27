import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:securenotes/authentication/authentication.dart';
import 'package:securenotes/models/notesmodel.dart';
import 'package:securenotes/models/notesprovider.dart';
import 'package:securenotes/screens/notesscreen.dart';
import 'package:securenotes/utils/firebasecollections.dart';
import 'package:securenotes/utils/global.dart';
import 'package:securenotes/utils/sharedpref.dart';


class UserSignUp extends StatefulWidget {

   UserSignUp({Key? key}) : super(key: key);

  @override
  _UserSignUpState createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
final  TextEditingController emailcontroller=TextEditingController();
List<NoteModel> notelist=[];
final TextEditingController passwordcontroller=TextEditingController();


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
      appBar: customAppBar(titlename: "Sign Up"),
      body: Container(
        margin: EdgeInsets.only(top: 40),
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Email",style: textStyle.copyWith(fontWeight: FontWeight.bold,fontSize: 15,),),
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
             Text("Password",style: textStyle.copyWith(fontWeight: FontWeight.bold,fontSize: 15,),),
            Container(
               padding: EdgeInsets.symmetric(vertical: 20),
              child: TextFormField(
                controller: passwordcontroller,
                decoration: InputDecoration(
                  hintText: "Please enter your password",
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
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: textcolor,padding: EdgeInsets.symmetric(horizontal: 30,vertical: 5)),
                onPressed: (){
                  if(checkvalidity()){
                     signupuser(context: context);
                  }
               
              }, child: Text("Sign Up")),
            )
          ],
        ),
      ),
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

  signupuser({BuildContext? context})async{
await auth.createUserWithEmailAndPassword(email: emailcontroller.text, password: passwordcontroller.text).then((value) async{
  if(value.user!=null){
    usercollection.doc(value.user?.uid).set({
      "uid":value.user?.uid,
      "email":value.user?.email,
      "password":passwordcontroller.text,
    });
    
      SharedPref.preferences.setString("uid", value.user?.uid??"");
      showsnackbar(context: context!,title: "We Are Very Delighted to welcome ${value.user?.email} to the SecureNotes");
        Provider.of<NoteListProvider>(context,listen: false).updatelist(listofnotes:notelist );
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>NotesSection()), (route) => false);

  }
}).catchError((error){
  debugPrint(error.message);
  if(error.code=="email-already-in-use"){
    showsnackbar(context: context,title: "Email already exist");
   
  }
  else if(error.code=="invalid-email"){
    showsnackbar(context: context,title:"Please enter a valid email" );
  }
  
  else{
    showsnackbar(context: context,title:"Some error occured" );
   
  }



}).onError((error, stackTrace) {
  print("erro:$error");
});
    
  }
}

