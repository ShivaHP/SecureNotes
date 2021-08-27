class NoteModel{
  String title;
  String description;
  String imageurl;
  String datecreated;
  String priority;
  String noteid;
  NoteModel({this.title="",this.description="",this.imageurl="",this.datecreated="",this.priority="0",this.noteid=""});

  factory NoteModel.fromMap({Map? doc}){
    if(doc==null)return NoteModel();
    return NoteModel(
      title: doc["title"],
      description: doc["description"],
      imageurl: doc["imageurl"],
      datecreated: doc["timestamp"],
      priority: doc["priority"],
      noteid: doc["noteid"]
    );
  }
}