import 'package:flutter/material.dart';
import 'remember_me.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_final/main.dart';
class RememberPage extends StatefulWidget {
  @override
  _RememberPageState createState() => _RememberPageState();
}

class _RememberPageState extends State<RememberPage> {
  var set = <String>{};
  var finalSet = <String>{};
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  bool _saving = true;
  int lengthSet = 0;



  @override
  Widget build(BuildContext context) {
    String collectionName = Provider.of<Data>(context).randomString;
    CollectionReference users = FirebaseFirestore.instance.collection(collectionName);

    return StreamBuilder<QuerySnapshot>(
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

