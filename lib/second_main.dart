import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_final/sub_main.dart';
import 'screen/search_page_card.dart';
import 'screen/history_page.dart';
import 'screen/remember_page.dart';

class SecondHomePage extends StatefulWidget {


  @override
  State createState() {
    return SecondHomePageState();
  }
}


class SecondHomePageState extends State<SecondHomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  String textMessage;

  String query;
  int _selectedIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _pageController = PageController(
      initialPage: _selectedIndex,
    );
  }

  void getCurrentUser(){
    final user = _auth.currentUser;
    if(user != null){
      loggedInUser = user;
      print(loggedInUser.email);
    }
  }



  List<Widget> _pageList = [
    HomePage(),
    // SearchPageCard(),
    HistoryPage(),
    RememberPage(),
  ];



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
            title: Text('Friends'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            title: Text('Remember'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 10), curve: Curves.easeIn);

        },
      ),
    );
  }

}
