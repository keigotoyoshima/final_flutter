import 'package:flutter/material.dart';
import 'remember_me.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';
class RememberPage extends StatefulWidget {
  @override
  _RememberPageState createState() => _RememberPageState();
}

class _RememberPageState extends State<RememberPage> {
  var set = <String>{};
  var finalSet = <String>{};
  final CollectionReference users = FirebaseFirestore.instance.collection(
      'remember');
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  bool _saving = true;
  int lengthSet = 0;

  getData()async{
     await users.get().then((QuerySnapshot querySnapshot) =>
    {
      querySnapshot.docs.forEach((doc) {
        lengthSet = finalSet.length;
        finalSet.add(doc["description"]);
        if(finalSet.length == lengthSet){
          users.doc(doc.id).delete().then((value) => print("User Deleted"))
              .catchError((error) => print("Failed to delete user: $error"));
        }
      })
    });
    setState(() {
      set = finalSet;
      _saving = false;
    });
  }


  @override
  void initState() {
    super.initState();
    getData();
  }


  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('remember');

    return ModalProgressHUD(
      inAsyncCall: _saving,
      child: StreamBuilder<QuerySnapshot>(
        stream: users.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          return ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return  Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, '/rememberMe', arguments:ScreenArguments(document.data()['description'], document.data()['meaning'],document.data()['part'], document.id));
                  },
                  child: ListTile(
                    tileColor: Colors.blue[100],
                    title: Text(document.data()['description'],style: TextStyle(fontSize: 30),),
                    subtitle:  Text(document.data()['part']),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}


  class ScreenArguments {
  final String description;
  final String meaning;
  final String part;
  final String id;

  ScreenArguments(this.description, this.meaning, this.part, this.id);
}

