import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note/component/custom_text_form.dart';
import 'package:note/screens/view_all_notes.dart';

class EditNote extends StatefulWidget {
  final String categoryId;
  final String idNote;
  final String oldNoteTitle;
  final String oldNoteContent;
  const EditNote(
      {super.key,
      required this.categoryId,
      required this.oldNoteTitle,
      required this.oldNoteContent,
      required this.idNote});
  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  TextEditingController noteTitleEdit = TextEditingController();
  TextEditingController noteContentEdit = TextEditingController();
  Future<void> editNote() async {
    CollectionReference notes =
    FirebaseFirestore.instance.collection('categories').doc(widget.categoryId).collection("note");
    // Call the user's CollectionReference to add a new user
    await notes
        .doc(widget.idNote)
        .update({
          "name1": noteTitleEdit.text,
          "name2": noteContentEdit.text,
        })
        .then((value) => print(
            "Note ${noteTitleEdit.text} and  ${noteContentEdit.text}  Added"))
        .catchError((error) => print("Failed to edit note: $error"));
  }

  @override
  void initState() {
    noteTitleEdit.text = widget.oldNoteTitle;
    noteContentEdit.text = widget.oldNoteContent;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    noteTitleEdit.dispose();
    noteContentEdit.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height:  MediaQuery.of(context).size.height*0.02,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, icon: const Icon(Icons.arrow_back,color: Colors.orange,)),
                      SizedBox(width: MediaQuery.of(context).size.width*0.01,),
                      const Text("Edit Notes",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                          fontSize: 20)),
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                    editNote();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  ViewAllNotes(categoryId:widget.categoryId),
                        ));
                  }, icon: const Icon(Icons.check,color: Colors.orange,size: 35,))
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.07,
              ),
              CustomTextForm(
                styleText: const TextStyle(fontWeight: FontWeight.bold,fontSize: 25),
                border: InputBorder.none,
                hintText: "Enter your Title",
                myController: noteTitleEdit,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              CustomTextForm(
                border: InputBorder.none,
                hintText: "Enter your content",
                myController: noteContentEdit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
