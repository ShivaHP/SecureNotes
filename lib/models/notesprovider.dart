import 'package:flutter/cupertino.dart';
import 'package:securenotes/models/notesmodel.dart';

class NoteListProvider with ChangeNotifier{
  List<NoteModel>? noteslist=[];

  addnote({@required NoteModel? noteModel}){
    noteslist?.add(noteModel??NoteModel());
    notifyListeners();
  }
  
  NoteListProvider({this.noteslist});
  updatelist({List<NoteModel>? listofnotes}){
    noteslist=listofnotes;
    notifyListeners();
  }
  upddatenote({NoteModel? noteModel}){
   noteslist?.forEach((element) { 
     if(element.noteid==noteModel?.noteid){
       print("found");
       element.title=noteModel?.title??"";
       element.description=noteModel?.description??"";
       element.datecreated=noteModel?.datecreated??"";
       element.imageurl=noteModel?.imageurl??"";
       element.priority=noteModel?.priority??"";
       element.noteid=noteModel?.noteid??"";
        notifyListeners();
     }
   });
  
  }
 NoteModel getdietnote({String noteid=""}){
   return noteslist?.singleWhere((element) => element.noteid==noteid)??NoteModel();
  }

  void deletenote({String noteid=""}){
    noteslist?.removeWhere((element) {
    return  element.noteid==noteid;
    } );
  }
}