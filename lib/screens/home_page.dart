import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.logout)),
      ),
      drawer: Drawer(),
      body:Center(
        child:Text("Hello",style: TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.bold,
          color: Colors.black
        ),),
      ),
    );
  }
}
