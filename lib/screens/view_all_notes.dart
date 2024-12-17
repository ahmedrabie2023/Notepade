import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:note/screens/add_note.dart';
import 'package:note/screens/edit_note.dart';
import 'package:note/screens/home_page.dart';
class ViewAllNotes extends StatefulWidget {
  final String categoryId;
   const ViewAllNotes({super.key, required this.categoryId});
  @override
  State<ViewAllNotes> createState() => _ViewAllNotesState();
}
class _ViewAllNotesState extends State<ViewAllNotes> {
  List<QueryDocumentSnapshot> notes = [];
  final _colors = [
    const Color(0xffFF5A33),
    const Color(0xffFFEC5C),
    const Color(0xffB4CF66),
    const Color(0xff44803F),
    const Color(0xff146152),
  ];
  var jiffy =Jiffy.now().format(pattern: 'MMM do yyyy, h:mm:ss a');
  bool isLoading = true;
  getNotes() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.categoryId)
        .collection("note")
        .get();
    notes.addAll(querySnapshot.docs);
    isLoading = false;
    setState(() {});
  }
  @override
  void initState() {
    getNotes();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Notes"),
          leading: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ));
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.orange[500],
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddNotes(categoryId: widget.categoryId),
                  ));
            }),
        body: isLoading == true
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    const Text("loading.......")
                  ],
                ),
              )
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                itemCount: notes.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder:(context) => EditNote(categoryId: widget.categoryId,
                            oldNoteTitle: notes[index]["name1"],
                            oldNoteContent: notes[index]["name2"],
                            idNote: notes[index].id), ));
                  },
                  child: GestureDetector(
                    onLongPress: (){
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.question,
                        animType: AnimType.rightSlide,
                        title: '${notes[index]['name1']}',
                        desc: ' do you want delete this item.......',
                        btnCancelColor: Colors.green,
                        btnCancelOnPress: () {
                        },
                        btnOkText: "Delete",
                        btnOkColor: Colors.red,
                        btnOkOnPress: () async {
                          await FirebaseFirestore.instance
                              .collection("categories").doc(widget.categoryId).collection("note").doc(notes[index].id).delete();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  ViewAllNotes(categoryId:widget.categoryId),
                              ));
                        },
                      ).show();
                    },
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.23,
                      child: Card(
                          color: _colors[index % _colors.length],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                    child: Text("${notes[index]["name1"]}",style: const TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)),
                                const SizedBox(height: 10,),
                                Align(
                                  alignment: Alignment.topLeft,
                                    child: Text("${notes[index]["name2"]}",maxLines: 3,)),
                                const SizedBox(height: 25,),
                                Align(
                                    alignment: Alignment.bottomRight,
                                    child:Text("$jiffy ")

                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ));
  }
}
