import 'package:flutter/material.dart';
import 'package:flutter_final/remember_me.dart';

class SecondHomePage extends StatefulWidget {
  SecondHomePage({Key key,this.itemsHistory, this.itemsRemember, this.queryParts, this.queryMeaning }) : super(key: key);

  final String queryParts;
  final String queryMeaning;
  final List<String> itemsHistory;
  final Set<String> itemsRemember;

  @override
  State createState() {
    return SecondHomePageState();
  }
}


class SecondHomePageState extends State<SecondHomePage> {
  String query;
  int _selectedIndex = 0;
  PageController _pageController;
  static String queryMeaning;
  static String queryParts;
  static List<String> itemsHistory;
  static Set<String> itemsRemember;

  void change() {
    itemsHistory =  widget.itemsHistory;
    itemsRemember = widget.itemsRemember;
    queryMeaning = widget.queryMeaning;
    queryParts = widget.queryParts;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _selectedIndex,
    );
    change();
    setState(() {
      _pageList[0] = SearchPageCard(queryMeaning: queryMeaning, queryParts: queryParts);
      _pageList[1] = HistoryPage(itemsHistory: itemsHistory);
      _pageList[2] = RememberPage(itemsRemember: itemsRemember);
    });
  }



  List<Widget> _pageList = [
    SearchPageCard(queryMeaning: queryMeaning, queryParts: queryParts),
    HistoryPage(itemsHistory: itemsHistory),
    RememberPage(itemsRemember: itemsRemember)
  ];

  void _onPageChanged(int index) {
    setState(() {

      _selectedIndex = index;
    });
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pageList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey,
        selectedItemColor: Colors.blueAccent,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text('History'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            title: Text('Remember'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          _selectedIndex = index;

          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 10), curve: Curves.easeIn);

        },
      ),
    );
  }

}

class RememberPage extends StatelessWidget {
  RememberPage({this.itemsRemember});

  final Set<String> itemsRemember;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,

        title: Text('Remember'),

      ),
      body: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: itemsRemember == null ? 0 : itemsRemember.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Card(
                        child: Container(
                          child: ListTile(
                            leading: null,
                            title: Text(
                                index.toString() + ", " + itemsRemember.elementAt(index),
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.black)
                            ),

                            onTap: () async{
                              final query = await Navigator.push(
                                context, MaterialPageRoute(builder:(context) => RememberMe(itemsRemember.elementAt(index)),
                              ),
                              );
                              if(query != null){
                                Navigator.pop(context, query);
                              }
                            },
                          ),
                          // added padding
                          padding: const EdgeInsets.all(15.0),
                        ),
                      )
                    ],
                  )),
            );
          }),

    );
  }
}


class HistoryPage extends StatelessWidget {


  HistoryPage({this.itemsHistory});
  final List<String> itemsHistory;



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,

        title: Text('History'),

      ),
      body: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: itemsHistory == null ? 0 : itemsHistory.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Card(
                        child: Container(
                          child: ListTile(
                              leading: null,
                              title: Text(
                                  index.toString()+ ", " + itemsHistory[index] ,
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.black)
                              ),

                              onTap: () {
                              }
                          ),
                          // added padding
                          padding: const EdgeInsets.all(15.0),
                        ),
                      )
                    ],
                  )),
            );
          }),

    );
  }
}

class SearchPageCard extends StatelessWidget {
  SearchPageCard({this.queryMeaning,this.queryParts});
  final String queryMeaning;
  final String queryParts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Search'),
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
                              "品詞:  " + queryParts,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black)
                          ),
                          subtitle: Text(
                              "意味:  " + queryMeaning,
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
