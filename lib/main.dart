import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_final/second_main.dart';
import 'package:http/http.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Response response;

  void getData() async{
    response = await get('https://raw.githubusercontent.com/keigotoyoshima/final_flutter/main/json/data.json');
  }

  @override
  void initState(){
    super.initState();
    getData();
  }


  List<String> itemsHistory = [];
  Set<String> itemsRemember = {};
  int lastNumber = 0;
  final _formKey = GlobalKey<FormState>();
  String query;
  String queryMeaning ;
  String queryParts ;
  List<dynamic> _data ;


  Future<void> loadJsonAsset(String query) async {
    final jsonResponse = json.decode(response.body);
    _data = jsonResponse[query];
    queryMeaning = _data[0]['description'];
    queryParts = _data[0]['a'];
    itemsHistory.add(query);
    itemsRemember.add(query);
  }

  @override
  Widget build(BuildContext context) {
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
                          hintText: '検索',
                          border: OutlineInputBorder(),
                          filled: true,
                        ),
                        onChanged: (value) {
                          query = value;
                        },

                      ),
                      TextButton(
                        onPressed: () async{
                          if(query != null) {
                            loadJsonAsset(query);
                            final result = await Navigator.push(
                              context, MaterialPageRoute(builder: (context) =>
                                SecondHomePage(itemsRemember: itemsRemember,
                                    itemsHistory: itemsHistory,
                                    queryMeaning: queryMeaning,
                                    queryParts: queryParts),
                            ),
                            );
                            query = null;
                            itemsRemember.remove(result);
                            _formKey.currentState.reset();
                          }
                        },
                        child: Text(
                          'Search&navi',
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