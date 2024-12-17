
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note/component/custom_text_form.dart';
import 'package:note/screens/view_all_notes.dart';
class AddNotes extends StatefulWidget {
  final String categoryId;
  const AddNotes({super.key, required this.categoryId});
  @override
  State<AddNotes> createState() => _AddNotesState();
}
class _AddNotesState extends State<AddNotes> {
  TextEditingController titleAdd = TextEditingController();
  TextEditingController contentAdd = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Future<void> addNote() {
    CollectionReference notes =
    FirebaseFirestore.instance.collection('categories').doc(widget.categoryId).collection("note");
    // Call the user's CollectionReference to add a new user
    return notes
        .add({
      "name1": titleAdd.text,
      "name2": contentAdd.text
    })
        .then((value) => print("Note ${titleAdd.text} and ${contentAdd.text} Added"))
        .catchError((error) => print("Failed to add note: $error"));
  }
  @override
  void dispose() {
    super.dispose();
    titleAdd.dispose();
    contentAdd.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Form(
          key: formKey,
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
                        SizedBox(width:  MediaQuery.of(context).size.width*0.01,),
                        const Text("Add Notes",style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                            fontSize: 20)),
                      ],
                    ),
                    IconButton(onPressed: (){
                      if (formKey.currentState!.validate()) {
                        addNote();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  ViewAllNotes(categoryId:widget.categoryId),
                            ));
                      }

                    }, icon: const Icon(Icons.check,color: Colors.orange,size: 35,))
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.07,
                ),
                CustomTextForm(
                  styleText: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                  border: InputBorder.none,
                  style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                  hintText: "Title",
                  myController: titleAdd,
                  validator: (val) {
                    if (val!.isEmpty || val == "") {
                      return "You must be enter title ";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.02,
                ),
                CustomTextForm(
                  border: InputBorder.none,
                  hintText: "Note something down",
                  myController: contentAdd,
                  validator: (val) {
                    if (val!.isEmpty || val == "") {
                      return "You must be enter content ";
                    } else {
                      return null;
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
