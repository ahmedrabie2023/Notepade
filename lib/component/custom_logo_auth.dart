import 'package:flutter/material.dart';
class CustomLogoAuth extends StatelessWidget {
  const CustomLogoAuth({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          alignment: Alignment.center,
          width:  MediaQuery.of(context).size.width*0.12,
          height: MediaQuery.of(context).size.height*0.12,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(70)),
          child: Image.asset(
            "images/note12.png",
            // fit: BoxFit.fill,
          )),
    );
  }
}