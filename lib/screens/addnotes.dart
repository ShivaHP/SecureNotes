import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:securenotes/models/notesmodel.dart';
import 'package:securenotes/models/notesprovider.dart';
import 'package:securenotes/utils/firebasecollections.dart';
import 'package:securenotes/utils/global.dart';
import 'package:securenotes/utils/sharedpref.dart';

class AddNotes extends StatefulWidget {
 final String lastscreen;
 final String noteid;
 final String title;
 final String description;
  const AddNotes({Key? key,this.lastscreen="home",this.noteid="0",this.title="",this.description=""}) : super(key: key);

  @override
  _AddNotesState createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  File file = File("");
  ImagePicker imagePicker = ImagePicker();
  bool uploadingdata = false;
  NoteModel noteModel=NoteModel();
  String imageurl="";
  List<NoteModel> notelist=[];
  String priority="0";
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titlecontroller.dispose();
    descriptioncontroller.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titlecontroller.text=widget.title;
    descriptioncontroller.text=widget.description;
  }
 

  @override
  Widget build(BuildContext context) {
    if(widget.lastscreen!="home"){
       noteModel=context.watch<NoteListProvider>().noteslist?.singleWhere((element) => element.noteid==widget.noteid)??NoteModel();
      imageurl=noteModel.imageurl;
      priority=noteModel.priority;
    }
    
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
         widget.lastscreen=="home"? "Add Notes":"Edit Notes",
          style: textStyle.copyWith(
              color: Color(0xff27335E),
              fontSize: 20,
              fontWeight: FontWeight.w800),
        ),
        leading: Builder(builder: (context) {
          return InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              width: 40,
              height: 40,
          
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              //  padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Color(0xffF3F4FD),
                  borderRadius: BorderRadius.circular(5)),
              child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Color(0xff68718C),
                  size: 20,
                ),
              ),
            ),
          );
        }),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.only(top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Title",
                style: textStyle.copyWith(
                    fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: TextFormField(
                  controller: titlecontroller,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: textcolor, width: 1.5)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: textcolor, width: 1.5))),
                ),
              ),
              Text(
                "Description",
                style: textStyle.copyWith(
                    fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 40),
                child: TextFormField(
                  controller: descriptioncontroller,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: textcolor, width: 1.5)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: textcolor, width: 1.5))),
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      getimage();
                    },
                    child: Container(
                      width: 40,
                      height: 40,

                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 0, left: 10, right: 50),
                      //  padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xffF3F4FD),
                          borderRadius: BorderRadius.circular(5)),
                      child: Icon(Icons.photo, color: Color(0xff68718C)),
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xff0A1747),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.symmetric(
                              horizontal:uploadingdata?40: 20, vertical: 8)),
                      onPressed: () {
                        if (validate()) {
                          print(file.path);
                        widget.lastscreen=="home"?saveuserdata():updatenotedata();
                        }
                      },
                      child: uploadingdata
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(),
                            )
                          : Text(widget.lastscreen=="home"?"Save Note":"Update Note"))
                ],
              ),
              Visibility(
                visible: file.path.isNotEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Preview",
                      style: textStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          fontStyle: FontStyle.italic),
                    ),
                    Container(
                      width: size.width * .5,
                      height: 300,
                      margin: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                          border: Border.all(color: textcolor, width: 0.0),
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                              fit: BoxFit.fill, image: FileImage(file))),
                    )
                  ],
                ),
              ),
               Visibility(
                visible:imageurl.isNotEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Old Image",
                      style: textStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          fontStyle: FontStyle.italic),
                    ),
                    Container(
                      width: size.width * .5,
                      height: 300,
                      margin: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                          border: Border.all(color: textcolor, width: 0.0),
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                              fit: BoxFit.fill, image: NetworkImage(imageurl))),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  updatenotedata()async{
     setState(() {
      uploadingdata = true;
    });
    String uid = SharedPref.getString(key: "uid");
    if(file.path.isNotEmpty){
       imageurl = await getimageurl();
    }

    
    notescollection
        .doc(uid)
        .collection("usernotes")
        .doc(widget.noteid
        )
        .update({
      "title": titlecontroller.text,
      "description": descriptioncontroller.text,
      "imageurl": imageurl,
      "timestamp":"${DateTime.now()}",
      "priority": priority,
      "noteid":widget.noteid
    });
    Provider.of<NoteListProvider>(context,listen: false).upddatenote(noteModel: NoteModel(
      title: titlecontroller.text,
      description: descriptioncontroller.text,
      datecreated: "${DateTime.now()}",
      priority: priority,
      imageurl: imageurl,
      noteid: widget.noteid
    ));
      uploadingdata = false;
      titlecontroller.clear();
      descriptioncontroller.clear();
      Navigator.pop(context);
      showsnackbar(context: context,title: "Your notes uploaded successfully");
  }

  saveuserdata() async {
    setState(() {
      uploadingdata = true;
    });
    String uid = SharedPref.getString(key: "uid");
    String imageurl = await getimageurl();
    String noteid=DateTime.now().millisecondsSinceEpoch.toString();
    notescollection
        .doc(uid)
        .collection("usernotes")
        .doc(noteid
        )
        .set({
      "title": titlecontroller.text,
      "description": descriptioncontroller.text,
      "imageurl": imageurl,
      "timestamp":"${DateTime.now()}",
      "priority": "0",
      "noteid":noteid
    });
    Provider.of<NoteListProvider>(context,listen: false).addnote(noteModel: NoteModel(
      title: titlecontroller.text,
      description: descriptioncontroller.text,
      imageurl: imageurl,
      datecreated: "${DateTime.now()}",
      noteid:noteid,
      priority: "0"
    ));
   
      uploadingdata = false;
      titlecontroller.clear();
      descriptioncontroller.clear();
      Navigator.pop(context);
      showsnackbar(context: context,title:"Your notes uploaded successfully" );
  
  }

  getimage() async {
    await imagePicker.pickImage(source: ImageSource.gallery).then((pickedfile) {
      if (pickedfile != null) {
        setState(() {
          file = File(pickedfile.path);
          imageurl="";
        });
      }
    });
  }

  bool validate() {
    if (titlecontroller.text.isEmpty) {
      showsnackbar(context: context,title:"Please enter a title" );
    
      return false;
    } else if (descriptioncontroller.text.isEmpty) {
      showsnackbar(context: context,title:"Please enter a description" );
     
      return false;
    } 
    else if (file.path.isEmpty) {
      if(widget.lastscreen=="home"){
        showsnackbar(context: context,title:"Please insert an image" );
          return false;
      }
      else{
        return true;
      }
    } else {
      return true;
    }
  }

  Future<String> getimageurl() {
    String imagepath = file.path.split("/")[6];
    if (imagepath.isEmpty) {
      imagepath = "image.jpg";
    }
    return firebaseStorage.ref().child(imagepath).putFile(file).then((value) {
      return value.ref.getDownloadURL();
    });
  }
}
