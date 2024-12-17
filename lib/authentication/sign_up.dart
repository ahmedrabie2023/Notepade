import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:note/authentication/login.dart';
import 'package:note/screens/home_page.dart';

import '../component/custom_button_auth.dart';
import '../component/custom_logo_auth.dart';
import '../component/custom_text_form.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordConfirm = TextEditingController();
  GlobalKey<FormState> fomKey =GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    username.dispose();
    email.dispose();
    password.dispose();
    passwordConfirm.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(children: [
          Form(
            key: fomKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height:  MediaQuery.of(context).size.height*0.02,),
                const CustomLogoAuth(),
                Container(height: 2),
                const Text("SignUp",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                Container(height:  MediaQuery.of(context).size.height*0.01,),
                const Text("SignUp To Continue Using The App",
                    style: TextStyle(color: Colors.grey)),
                Container(height:  MediaQuery.of(context).size.height*0.03,),
                const Text(
                  "username",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(height:  MediaQuery.of(context).size.height*0.01,),
                CustomTextForm(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(width: 2),
                    ),
                  validator: (val){
                    if(val!.isEmpty ||val=="")
                    {
                      return "You must be enter the UserName";
                    }
                    return null;
                  },
                    hintText: "ُEnter Your username", myController: username),
                Container(height:  MediaQuery.of(context).size.height*0.03,),
                const Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(height:  MediaQuery.of(context).size.height*0.01,),
                CustomTextForm(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(width: 2),
                    ),
                    validator: (val){
                      if(val!.isEmpty ||val=="")
                      {
                        return "You must be enter the Email";
                      }
                      else if (!val.endsWith("@gmail.com"))
                      {
                        return "Your Email must be End With @gmail.com";
                      }
                      return null;

                    },
                    hintText: "ُEnter Your Email", myController: email),
                Container(height:  MediaQuery.of(context).size.height*0.01,),
                const Text(
                  "Password",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(height:  MediaQuery.of(context).size.height*0.01,),
                CustomTextForm(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(width: 2),
                    ),
                    validator: (val){
                      if(val!.isEmpty ||val=="")
                      {
                        return "You must be enter the password";
                      }
                      return null;

                    },
                    hintText: "ُEnter Your Password", myController: password),
                Container(height:  MediaQuery.of(context).size.height*0.01,),
                const Text(
                  "Confirm Password",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(height:  MediaQuery.of(context).size.height*0.01,),
                CustomTextForm(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(width: 2),
                    ),
                    validator: (val){
                      if(val!.isEmpty ||val=="")
                      {
                        return "You must be enter the UserName";
                      }
                      else if(passwordConfirm.text!=password.text)
                      {
                        return "this password not match ";
                      }
                      return null;

                    },
                    hintText: "ُEnter Your Confirm Password",
                    myController: passwordConfirm),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 20),
                  alignment: Alignment.topRight,
                  child: const Text(
                    "Forgot Password ?",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomButtonAuth(
              title: "SignUp",
              onPressed: () async {
                if(fomKey.currentState!.validate())
                {
                  try {
                    final credential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: email.text,
                      password: password.text,
                    );
                    FirebaseAuth.instance.currentUser!.sendEmailVerification();
                    print("send email");
                    if(credential.user!.emailVerified)
                    {
                      print("done verify");
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                            (route) => false,
                      );
                    }
                    else
                    {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.noHeader,
                        animType: AnimType.rightSlide,
                        desc: 'Please go to your email and activate your account...',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {},
                      ).show();
                    }

                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      if (kDebugMode) {
                        print('The password provided is too weak.');
                      }
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'The password provided is too weak......',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {},
                      ).show();
                    } else if (e.code == 'email-already-in-use') {
                      if (kDebugMode) {
                        print('The account already exists for that email.');
                      }
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'The account already exists for that email....',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {},
                      ).show();
                    }
                  } catch (e) {
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                }
              }),
          Container(height:  MediaQuery.of(context).size.height*0.01,),
          Container(height:  MediaQuery.of(context).size.height*0.01,),
          // Text("Don't Have An Account ? Resister" , textAlign: TextAlign.center,)
          InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const Login(),
                ),
                (route) => false,
              );
            },
            child: const Center(
              child: Text.rich(TextSpan(children: [
                TextSpan(
                  text: "Have An Account ? ",
                  style: TextStyle(fontSize: 18),
                ),
                TextSpan(
                    text: "Login",
                    style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
              ])),
            ),
          )
        ]),
      ),
    );
  }
}
