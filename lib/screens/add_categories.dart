import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note/component/custom_text_form.dart';
import 'package:note/screens/home_page.dart';
class AddCategories extends StatefulWidget {
  const AddCategories({super.key});
  @override
  State<AddCategories> createState() => _AddCategoriesState();
}

class _AddCategoriesState extends State<AddCategories> {
  TextEditingController categoriesAdd = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  Future<void> addCategory() {
    // Call the user's CollectionReference to add a new user
    return categories
        .add({
          "name": categoriesAdd.text,
          "id": FirebaseAuth.instance.currentUser!.uid,
        })
        .then((value) => print("Category ${categoriesAdd.text} Added"))
        .catchError((error) => print("Failed to add category: $error"));
  }
  @override
  void dispose() {
    super.dispose();
    categoriesAdd.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Categories"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                 SizedBox(
                  height: MediaQuery.of(context).size.height*0.14,
                ),
                CustomTextForm(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(width: 2),
                  ),
                  hintText: "Enter your categories",
                  myController: categoriesAdd,
                  validator: (val) {
                    if (val!.isEmpty || val == "") {
                      return "You must be enter categories ";
                    } else {
                      return null;
                    }
                  },
                ),
                 SizedBox(
                  height: MediaQuery.of(context).size.height*0.04,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        addCategory();
                      }
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
                      "Add",
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
