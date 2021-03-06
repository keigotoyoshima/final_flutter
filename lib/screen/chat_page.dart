import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

User loggedInUser;
class ChatPage extends StatefulWidget {

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;




  @override
  void initState() {
    super.initState();
    getCurrentUser();


  }
  void getCurrentUser(){
    final user = _auth.currentUser;
    if(user != null){
      loggedInUser = user;
      print(loggedInUser.email);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,

        title: Text('Friends'),

      ),
      body:   UserInformation(),

    );
  }
}

class UserInformation extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {

  ScrollController _scrollController;
  final double maxScrollExtent = 0.0;


  @override
  Widget build(BuildContext context) {
    Query collectionReference = FirebaseFirestore.instance.collection("chat").orderBy('time', descending: true);
    return StreamBuilder<QuerySnapshot>(
      stream: collectionReference.snapshots(),
      builder: (BuildContext context,  snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        return  ListView(
          reverse: true,
          shrinkWrap: true,
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            return  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  crossAxisAlignment: document.data()['sender'] == loggedInUser.email ? CrossAxisAlignment.end: CrossAxisAlignment.start,
                  children: <Widget>[
                    Material(
                      color: Colors.blue,
                      borderRadius: document.data()['sender'] == loggedInUser.email ?
                      BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)):
                      BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Text(document.data()['description'],
                          style: TextStyle(fontSize: 25),),
                      ),
                    ),
                    Text(document.data()['word'],
                      style: TextStyle(fontSize: 15),),
                    Text(document.data()['sender'],
                      style: TextStyle(fontSize: 15),)
                  ],
                )
            );
          }).toList(),
        );
      },
    );
  }
}


