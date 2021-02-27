import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';

class RememberMe extends StatefulWidget {

  RememberMe(this.query);
  final String query;


  @override
  _RememberMeState createState() => _RememberMeState();
}

class _RememberMeState extends State<RememberMe> {

  String queryMeaning = "???";
  String queryParts  = "???";
  List<dynamic> _data ;
  Response response;


  void getData() async{
    response = await get('https://raw.githubusercontent.com/keigotoyoshima/flutter/main/json/data.json');
  }

  @override
  void initState(){
    super.initState();
    getData();
  }
  Future<void> loadJsonAsset(String query) async {
    final jsonResponse = json.decode(response.body);
    _data = jsonResponse[query];
    queryMeaning = _data[0]['description'];
    queryParts = _data[0]['a'];
  }





  @override
  Widget build(BuildContext context) {
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
                          title: Text("意味: "+queryMeaning),
                          subtitle: Text(
                            "品詞: "+queryParts,
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
                                Navigator.pop(context, widget.query);
                              },
                              child: const Text(
                                '覚えたボタン',
                                style:TextStyle(color: Colors.red) ,
                              ),
                            ),

                            TextButton(
                              onPressed: () {
                                setState(() {
                                  loadJsonAsset(widget.query);
                                });
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
