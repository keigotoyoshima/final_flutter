import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:http/http.dart';
import 'remember_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_final/main.dart';


class RememberMe extends StatefulWidget {


  @override
  _RememberMeState createState() => _RememberMeState();
}

class _RememberMeState extends State<RememberMe> {


  Map<String, dynamic> _data ;
  Response response;

  final CollectionReference users = FirebaseFirestore.instance.collection(
      'remember');



  void getData() async {
    response =
    await http.get(Uri.https('raw.githubusercontent.com', 'keigotoyoshima/final_flutter/main/data/data.json'));
  }

  @override
  void initState(){
    super.initState();
    getData();
  }





  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Search'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                children:<Widget> [
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        ListTile(
                          leading: null,
                          title: Text("意味: "+ Provider.of<Data>(context).description),
                          subtitle: Text(
                            "品詞: "+Provider.of<Data>(context).part,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            '覚えましたか？？',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () {
                                users.doc(args.id).delete().then((value) => print("User Deleted"))
                                    .catchError((error) => print("Failed to delete user: $error"));
                                Navigator.pop(context, null);

                              },
                              child: const Text(
                                '覚えたボタン',
                                style:TextStyle(color: Colors.red) ,
                              ),
                            ),

                            TextButton(
                              onPressed: () {
                                Provider.of<Data>(context, listen: false).changeString(args.meaning, args.part);
                              },
                              child: const Text(
                                '表示',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, null);
                              },
                              child: const Text(
                                '保留',
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ]
            )
        )

    );

  }

}
