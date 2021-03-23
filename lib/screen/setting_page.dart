import 'package:flutter/material.dart';
import 'package:flutter_final/main.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class SettingPage extends StatelessWidget {
  final CollectionReference _collectionReference = FirebaseFirestore.instance.collection('remember');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          children: <Widget>[
            DeleteButton(color: Colors.deepOrangeAccent, text: 'chat履歴を消す',),
            Expanded(flex: 1,child: SizedBox()),
            DeleteButton(color: Colors.redAccent, text: 'remember履歴を消す',
              function: (){
                Provider.of<Data>(context, listen: false).resetSet();
                _collectionReference.snapshots().forEach((element) {
                for (QueryDocumentSnapshot snapshot in element.docs) {
                snapshot.reference.delete();
                }
                });
                Provider.of<Data>(context, listen: false).changeCollectionName();
                }

            ),
          ],
        ),
      ),
    );
  }
}

class DeleteButton extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Color color;
  final String text;
  final Function function;
  DeleteButton({this.text, this.color, this.function});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 7,
      child: GestureDetector(
        onTap:function,
        child: Center(
          child: Material(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(30)),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text(text,
                style: TextStyle(fontSize: 25),),
            ),
          ),
        ),
      ),
    );
  }
}
