import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../components/constants.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _saving = false;
  String email;
  String password;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _saving,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('register'),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                  onChanged: (value) {
                    email = value;
                  },
                  decoration:kInputDecoration.copyWith(hintText: 'Input your email')
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kInputDecoration.copyWith(hintText: 'Input your password')
              ),
              SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () async{
                      setState(() {
                        _saving = true;
                      });
                      try {
                        UserCredential userCredential = await _auth
                            .createUserWithEmailAndPassword(
                            email: email, password: password);
                        setState(() {
                          _saving = false;
                        });
                        if (userCredential != null) {
                          Navigator.pushNamed(context, '/secondHome');
                        }
                      } catch(e){
                        setState(() {
                          _saving = false;
                        });
                        print(e);
                      }
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}