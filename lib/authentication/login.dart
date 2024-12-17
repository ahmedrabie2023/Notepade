import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:note/authentication/sign_up.dart';
import 'package:note/screens/home_page.dart';
import '../component/custom_button_auth.dart';
import '../component/custom_logo_auth.dart';
import '../component/custom_text_form.dart';
import 'package:google_sign_in/google_sign_in.dart';
class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
      (route) => false,
    );
  }
  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(children: [
          Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height:  MediaQuery.of(context).size.height*0.07,),
                const CustomLogoAuth(),
                Container(height:  MediaQuery.of(context).size.height*0.05,),
                const Text("Login",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                Container(height:  MediaQuery.of(context).size.height*0.02,),
                const Text("Login To Continue Using The App",
                    style: TextStyle(color: Colors.grey)),
                Container(height:  MediaQuery.of(context).size.height*0.05,),
                const Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(height:  MediaQuery.of(context).size.height*0.02,),
                CustomTextForm(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(width: 2),
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "You must be enter your email";
                      }
                      else if (!val.endsWith("@gmail.com"))
                      {
                        return "Your Email must be End With @gmail.com";
                      }
                      return null;
                    },
                    hintText: "ُEnter Your Email",
                    myController: email),
                Container(height:  MediaQuery.of(context).size.height*0.02,),
                const Text(
                  "Password",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(height:  MediaQuery.of(context).size.height*0.02,),
                CustomTextForm(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(width: 2),
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "You must be enter your password";
                      } else {
                        return null;
                      }
                    },
                    hintText: "ُEnter Your Password",
                    myController: password),
                InkWell(
                  onTap: () async {
                    if(email.text=="")
                    {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        desc: 'Please Write your email in field...',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {},
                      ).show();
                      return;
                    }
                   try
                   {
                     await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
                     AwesomeDialog(
                       context: context,
                       dialogType: DialogType.success,
                       animType: AnimType.rightSlide,
                       desc: 'Please go to your email and reset password...',
                       btnCancelOnPress: () {},
                       btnOkOnPress: () {},
                     ).show();

                   } catch(e) {
                     AwesomeDialog(
                       context: context,
                       dialogType: DialogType.error,
                       animType: AnimType.rightSlide,
                       desc: 'This email not exit!!...',
                       btnCancelOnPress: () {},
                       btnOkOnPress: () {},
                     ).show();
                   }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 15),
                    alignment: Alignment.topRight,
                    child: const Text(
                      "Forgot Password ?",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomButtonAuth(
              title: "Login",
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    final credential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: email.text, password: password.text);
                    if (credential.user!.emailVerified) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                        (route) => false,
                      );
                    } else {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.noHeader,
                        animType: AnimType.rightSlide,
                        desc:
                            'Please go to your email and activate your account...',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {},
                      ).show();
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      if (kDebugMode) {
                        print('No user found for that email.');
                      }
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'No user found for that email....',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {},
                      ).show();
                    } else if (e.code == 'wrong-password') {
                      if (kDebugMode) {
                        print('Wrong password provided for that user.');
                      }
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'Wrong password provided for that user...',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {},
                      ).show();
                    }
                  }
                }
              }),
          Container(height:  MediaQuery.of(context).size.height*0.03,),
          const Align(
              alignment: Alignment.center,
              child: Text(
                "SignUp With",
                style: TextStyle(fontSize: 20),
              )),
           SizedBox(
            height:  MediaQuery.of(context).size.height*0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  signInWithGoogle();
                },
                child: Container(
                    width:  MediaQuery.of(context).size.width*0.14,
                    height:  MediaQuery.of(context).size.height*0.12,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12, width: 2),
                    ),
                    child: Image.asset("images/google.png")),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                    width:  MediaQuery.of(context).size.width*0.14,
                    height:  MediaQuery.of(context).size.height*0.12,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12, width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Image.asset("images/download (1).png"),
                    )),
              ),
            ],
          ),
          Container(height:  MediaQuery.of(context).size.height*0.05,),
          // Text("Don't Have An Account ? Resister" , textAlign: TextAlign.center,)
          InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignUp(),
                ),
                (route) => false,
              );
            },
            child: const Center(
              child: Text.rich(TextSpan(children: [
                TextSpan(
                    text: "Don't Have An Account ? ",
                    style: TextStyle(fontSize: 18)),
                TextSpan(
                    text: "Register",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold)),
              ])),
            ),
          )
        ]),
      ),
    );
  }
}
