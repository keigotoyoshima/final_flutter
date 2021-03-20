import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_final/sub_main.dart';
import 'package:flutter_final/screen/remember_me.dart';
import 'login_and_register/login_register_widet.dart';
import 'login_and_register/register_page.dart';
import 'login_and_register/login_page.dart';
import 'second_main.dart';
import 'screen/search_page_card.dart';
import 'package:provider/provider.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text('snapshot has error', style: TextStyle(fontSize: 80),);
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return FlashChat();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}


class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Data(),
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.red,
            primarySwatch: Colors.red
        ),
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => WelcomeScreen(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/home': (context) => HomePage(),
          '/searchCard': ( context) => SearchPageCard(),
          '/secondHome':(context) => SecondHomePage(),
          '/login': (context) => LoginScreen(),
          '/registration': (context) => RegistrationScreen(),
          '/rememberMe':(context) => RememberMe(),
        },

      ),
    );
  }
}


class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 200, 30, 250),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right:20.0),

              ),
            ),
            SizedBox(
              height: 20,
            ),

            LoginRegisterWidget(
              color: Colors.lightBlueAccent,
              onPress:(){
                Navigator.pushNamed(context, '/login');
              },
              text: 'Log In',
            ),
            LoginRegisterWidget(
                color: Colors.blueAccent,
                onPress: () {
                  Navigator.pushNamed(
                      context,
                      '/registration',
                  );
                },
                text:  'Register')

          ],
        ),
      ),
    );
  }
}

class Data extends ChangeNotifier{
  String description = "???";
  String part  = "???";

  void changeString(String des, String par){
    description = des;
    part = par;
    notifyListeners();
  }

}

