
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:securenotes/models/notesmodel.dart';
import 'package:securenotes/models/notesprovider.dart';
import 'package:securenotes/screens/addnotes.dart';
import 'package:securenotes/utils/firebasecollections.dart';
import 'package:securenotes/utils/global.dart';

class NoteDetails extends StatelessWidget {
  final String noteid;
  final String uid;
 late NoteModel note;
  ValueNotifier<bool> priority=ValueNotifier<bool>(false);
   NoteDetails({Key? key, this.noteid = "", this.uid = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    note=context.watch<NoteListProvider>().getdietnote(noteid: noteid);
    priority.value=note.priority=="0"?false:true;
    return Scaffold(
      // bottomNavigationBar: buildmybottombar(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
              child: Icon(Icons.arrow_back_ios_new,
                  size: 20, color: Color(0xff68718C)),
            ),
          );
        }),
      ),
      body:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                     height: MediaQuery.of(context).size.height * .785,
                      padding: EdgeInsets.only(top: 20),
                      margin: EdgeInsets.only(top: 30),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          gradient: LinearGradient(
                            colors: [Color(0xffF5F6FD), Colors.white],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(3, 3),
                                color: Colors.black12,
                                spreadRadius: 2,
                                blurRadius: 2)
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SizedBox(height: 30,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "${note.title}",
                              style: textStyle.copyWith(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Divider(
                            height: 20,
                            thickness: 0.5,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "${note.description}",
                                  style: textStyle.copyWith(
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Text(
                                  dateformatter(
                                      DateTime.parse(note.datecreated)),
                                  style: textStyle.copyWith(
                                      fontSize: 10,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey.shade500),
                                ),
                                Spacer(
                                  flex: 3,
                                ),
                                InkWell(
                                  onTap: (){
                                    showimagedialog(imageurl:note.imageurl,context: context);
                                  },
                                  child: Icon(
                                    Icons.photo,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.mic,
                                  color: Colors.grey.shade500,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 1,
                      child: Container(
                        //color: Color(0xffEAEDFA),
                        padding: EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddNotes(
                                                noteid: noteid,
                                                lastscreen: "notedetails",
                                                title: note.title,
                                                description: note.description,
                                              )));
                                },
                                child: Icon(Icons.edit,
                                    color: textcolor, size: 28)),
                            ValueListenableBuilder(
                              valueListenable: priority,
                              builder:(context,value,widget){
                                return InkWell(
                                onTap: () {
                                  priority.value=!priority.value;
                                  notescollection
                                      .doc(uid)
                                      .collection("usernotes")
                                      .doc(noteid)
                                      .update({
                                    "title":note.title,
                                    "description":note.description,
                                    "imageurl": note.imageurl,
                                    "timestamp": "${DateTime.now()}",
                                    "priority": priority.value?"1":"0",
                                    "noteid": noteid
                                  });
                                Provider.of<NoteListProvider>(context,listen: false).upddatenote(noteModel: NoteModel(
                                  title: note.title,
                                  description: note.description,
                                  imageurl: note.imageurl,
                                  datecreated: "${DateTime.now()}",
                                  priority: priority.value?"1":"0",
                                  noteid: noteid
                                ));
                                },
                                child: Icon(
                                  priority.value == false
                                      ? Icons.star_border_outlined
                                      : Icons.star,
                                  color: priority.value == false
                                      ? Colors.grey
                                      : Colors.orange,
                                  size: 28,
                                ),
                              );
                              } 
                            ),
                            Icon(
                              Icons.share,
                              color: textcolor,
                              size: 28,
                            ),
                            Icon(
                              Icons.more_vert,
                              color: textcolor,
                              size: 28,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
    );
    
  }
   
 
}
showimagedialog({String imageurl="",@required BuildContext? context})async{
    return await showDialog(context: context!, builder:(context){
      return Container(
        margin: EdgeInsets.symmetric(vertical: 100),
      //  height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage(imageurl)
          )
        ),
      );
    } );
  }