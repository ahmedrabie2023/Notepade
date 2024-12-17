import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note/component/custom_text_form.dart';
import 'package:note/screens/home_page.dart';

class EditCategories extends StatefulWidget {
  final String idDoc;
  final oldCategory;
  const EditCategories(
      {super.key, required this.idDoc, required this.oldCategory});
  @override
  State<EditCategories> createState() => _EditCategoriesState();
}

class _EditCategoriesState extends State<EditCategories> {
  TextEditingController categoriesEdit = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  Future<void> editCategory() async {
    await categories
        .doc(widget.idDoc)
        .update({"name": categoriesEdit.text})
        .then((value) => print("Category ${categoriesEdit.text} Added"))
        .catchError((error) => print("Failed to add category: $error"));
  }

  @override
  void initState() {
    categoriesEdit.text = widget.oldCategory;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    categoriesEdit.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Categories"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.14,
            ),
            CustomTextForm(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(width: 2),
              ),
              hintText: "Enter your categories",
              myController: categoriesEdit,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            ElevatedButton(
                onPressed: () {
                  editCategory();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 60),
                    backgroundColor: Colors.orange),
                child: const Text(
                  "Save",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}
