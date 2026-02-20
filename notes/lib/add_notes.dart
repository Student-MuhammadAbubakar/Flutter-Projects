import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class addnotes extends StatefulWidget {
  const addnotes({super.key});

  @override
  State<addnotes> createState() {
    return MyAddNotes();
  }
}

class MyAddNotes extends State<addnotes> {
  final TextEditingController _addController = TextEditingController();
  final TextEditingController _addDescription = TextEditingController();
 @override
 void dispose(){
   _addDescription.dispose();
   _addController.dispose();
   super.dispose();
 }
 void Handledone(){
   _addController.clear();
   _addDescription.clear();
 }
  addnotes(String title,String desc)async{
    if(title==""&&desc==""){
      log("Enter the required field ");
    }
    else{
      FirebaseFirestore.instance.collection("Users").doc(title).set({
        "Title":title,
        "Description":desc,
      }).then((value){
        log("Value inserted");
      });
      await Future.delayed(const Duration(milliseconds: 500));
      // Go back to previous screen (home screen)
      Navigator.pop(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(
          "Add Notes",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: _addController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Enter your Title here..",
                hintText: "Enter Title ",
                suffixIcon: Icon(Icons.title),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.lightBlue),
                ),
              ),
              minLines: 1,
              maxLines: 2,
              keyboardType: TextInputType.text,
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: _addDescription,
              decoration: InputDecoration(
                labelText: "Enter Description",
                hintText: "Enter Description Here...",
                suffixIcon: Icon(Icons.description),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.lightBlue),
                ),
              ),
              minLines: 1,
              maxLines: 5,
              keyboardType: TextInputType.text,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addnotes(_addController.text.toString(), _addDescription.text.toString());
          Handledone();
        },
        backgroundColor: Colors.cyan,
        child: Icon(Icons.done),
      ),
    );
  }
}
