import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:flutter_final/main.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  var _controller = TextEditingController();
  var time;
  User loggedInUser;
  User user;
  String textMessage;
  Response response;
  bool _saving = false;

  @override
  void initState(){
    super.initState();
    getData();
    getCurrentUser();
  }

  final _formKey = GlobalKey<FormState>();
  String query;
  String queryMeaning ;
  String queryParts ;
  Map<String, dynamic> _data ;

  void getData() async {
    response =
    await http.get(Uri.https('raw.githubusercontent.com', 'keigotoyoshima/final_flutter/main/data/data.json'));
  }

  void getCurrentUser(){
    user = _auth.currentUser;
    if(user != null){
      loggedInUser = user;
    }
  }

  Future<String> loadJsonAsset(String query) async {
    final jsonResponse = json.decode(response.body);
    try {
      _data = jsonResponse[query];
      queryMeaning = _data['description'];
      queryParts = _data['a'];
    } catch(e){
      print(e);
      return null;
    }
    return query;
  }

  @override
  Widget build(BuildContext context) {
    String collectionName = Provider.of<Data>(context).randomString;
    int setOfLength = Provider.of<Data>(context).set.length;
    var set = Provider.of<Data>(context).set;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('検索'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: Provider.of<Data>(context).set.length.toString(),
                          border: OutlineInputBorder(),
                          filled: true,
                        ),
                        onChanged: (value) {
                          query = value;
                        },

                      ),
                      TextButton(
                        onPressed: () async{
                          String value;
                          if(query != null)  value = await loadJsonAsset(query);

                          if(value != null) {
                             await loadJsonAsset(query);
                            _controller.clear();
                            time = DateTime.now();
                            _firestore.collection('chat').add({
                              'description' : query,
                              'word': queryMeaning,
                              'a' : queryParts,
                              'time': time,
                              'sender': loggedInUser.email,
                            })
                                .then((value) => print("User Added history: $value"))
                                .catchError((error) => print("Failed to add user: $error"));
                            int first = setOfLength;
                            print(first.toString()+' first ');
                            set.add(query);
                            Provider.of<Data>(context, listen: false).addSet(query);
                            int second = set.length;
                            print(second.toString()+' second');
                            if(first != second){
                              print('remember output '+collectionName);
                              _firestore.collection(collectionName).add({
                                'description' : query,
                                'meaning' : queryMeaning,
                                'part':queryParts,
                              })
                                  .then((value) => print("User Added remember: $value"))
                                  .catchError((error) => print("Failed to add user: $error"));
                            }
                            _formKey.currentState.reset();
                             Navigator.pushNamed(
                               context,
                               '/searchCard',
                               arguments: SearchData(queryMeaning: queryMeaning, queryParts: queryParts)
                             );

                          }else{
                            print('error catch');
                          }
                        },
                        child: Text(
                          'Search',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchData{
  final String queryMeaning;
  final String queryParts;
  SearchData({this.queryParts, this.queryMeaning});
}