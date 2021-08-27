import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:securenotes/authentication/authentication.dart';
import 'package:securenotes/models/notesmodel.dart';
import 'package:securenotes/models/notesprovider.dart';
import 'package:securenotes/screens/addnotes.dart';
import 'package:securenotes/screens/notedetails.dart';
import 'package:securenotes/screens/splashscreen.dart';
import 'package:securenotes/utils/firebasecollections.dart';
import 'package:securenotes/utils/global.dart';
import 'package:securenotes/utils/sharedpref.dart';

class NotesSection extends StatefulWidget {
  NotesSection({Key? key}) : super(key: key);

  @override
  _NotesSectionState createState() => _NotesSectionState();
}

class _NotesSectionState extends State<NotesSection> {
  final String uid = SharedPref.getString(key: "uid");
  List<NoteModel> helpernotelist = [];
  List<NoteModel> noteslist = [];
  TextEditingController searchcontroller = TextEditingController();
  bool showsearchbar = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchcontroller.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    noteslist =
        Provider.of<NoteListProvider>(context, listen: true).noteslist ?? [];
    noteslist.sort((a, b) => b.datecreated.compareTo(a.datecreated));
    noteslist.sort((a, b) => b.priority.compareTo(a.priority));
    helpernotelist = noteslist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Container(
          width: MediaQuery.of(context).size.width * .7,
          child: Drawer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 40, bottom: 10),
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: NetworkImage(
                        "https://w7.pngwing.com/pngs/340/946/png-transparent-avatar-user-computer-icons-software-developer-avatar-child-face-heroes-thumbnail.png"),
                  ),
                ),
                TextButton.icon(
                    onPressed: null,
                    icon: Icon(Icons.email_outlined),
                    label: Text(auth.currentUser?.email ?? "")),
                TextButton.icon(
                    onPressed: () {
                      WidgetsBinding.instance
                          ?.addPostFrameCallback((timeStamp) {
                        SharedPref.preferences.clear();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SplashScreen()),
                            (route) => false);
                      });
                    },
                    icon: Icon(Icons.logout_outlined),
                    label: Text("Logout"))
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Color(0xff0A1747),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddNotes();
            }));
          },
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "MyNotes",
            style: textStyle.copyWith(
                color: Color(0xff27335E),
                fontSize: 20,
                fontWeight: FontWeight.w800),
          ),
          leading: Builder(builder: (context) {
            return InkWell(
              onTap: () {
                Scaffold.of(context).openDrawer();
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
                child: Icon(Icons.menu, color: Color(0xff68718C)),
              ),
            );
          }),
          actions: [
            InkWell(
              onTap: () {
                setState(() {
                  showsearchbar = !showsearchbar;
                  noteslist = helpernotelist;
                });
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
                child: Icon(Icons.search_outlined, color: Color(0xff68718C)),
              ),
            )
          ],
        ),
        body: Container(
            child: Column(
          children: [
            AnimatedContainer(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              duration: Duration(milliseconds: 600),
              curve: Curves.easeIn,
              height: showsearchbar ? 100 : 0,
              child: Visibility(
                visible: showsearchbar,
                child: TextFormField(
                  controller: searchcontroller,
                  onChanged: (String text) {
                    noteslist = helpernotelist.where((element) {
                      return element.title
                          .toLowerCase()
                          .contains(text.toLowerCase());
                    }).toList();
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      hintText: "Search by title",
                      suffixIcon: IconButton(
                          onPressed: () {
                            searchcontroller.clear();
                          },
                          icon: Icon(
                            Icons.clear_outlined,
                            color: textcolor,
                          )),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: textcolor, width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: textcolor, width: 1))),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: noteslist.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NoteDetails(
                                      noteid: noteslist[index].noteid,
                                      uid: uid,
                                    )));
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                top: 25, left: 12, right: 0, bottom: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        noteslist[index].title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: textStyle.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        noteslist[index].description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: textStyle.copyWith(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Icon(
                                            noteslist[index].priority == "0"
                                                ? Icons.star_border_outlined
                                                : Icons.star,
                                            color:
                                                noteslist[index].priority ==
                                                        "0"
                                                    ? Colors.grey
                                                    : Color(0xffF29F05),
                                            size: 20,
                                          ),
                                          PopupMenuButton(
                                              // initialValue: "Preview Image",
                                              padding: EdgeInsets.zero,
                                              onSelected: (value) async {
                                                print("value:$value");
                                                if (value == "Preview Image") {
                                                  await showimagedialog(
                                                      context: context,
                                                      imageurl: noteslist[index]
                                                          .imageurl);
                                                } else {
                                                  deletenote(
                                                      noteid: noteslist[index]
                                                          .noteid);
                                                }
                                              },
                                              itemBuilder: (context) => [
                                                    "Preview Image",
                                                    "Delete Note"
                                                  ]
                                                      .map((e) => PopupMenuItem(
                                                          value: e,
                                                          child: Text(e)))
                                                      .toList())
                                        ],
                                      ),
                                      // SizedBox(
                                      //   height: 20,
                                      // ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Text(
                                          dateformatter(DateTime.parse(
                                              noteslist[index].datecreated)),
                                          style: textStyle.copyWith(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.grey,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            height: 1.5,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        )));
  }

  deletenote({String noteid = ""}) {
    context.read<NoteListProvider>().deletenote(noteid: noteid);
    notescollection.doc(uid).collection("usernotes").doc(noteid).delete();
    setState(() {});
  }
}
