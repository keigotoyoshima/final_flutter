import 'package:flutter/material.dart';
import 'package:flutter_final/screen/search_page.dart';

class SearchPageCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final SearchData data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text('result'),
        ),
        body:Container(
          child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment
                    .stretch,
                children: <Widget>[
                  Card(
                    child: Container(
                      child: ListTile(
                          leading: null,
                          title: Text(
                              "品詞:  " + data.queryParts,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black)
                          ),
                          subtitle: Text(
                              "意味:  " + data.queryMeaning,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black)
                          ),
                          onTap: () {

                          }
                      ),
                      // added padding
                    ),
                  ),
                ],
              )),
        )
    );
  }
}
