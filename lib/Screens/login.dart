import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './HomeScreen.dart';
import '../Service/Authentication.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isSigningIn = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      color: Colors.deepPurple.shade500,
      child: Scaffold(
        backgroundColor: Colors.deepPurple.shade500,
        body: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 40,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Row(),
              //  Flexible(flex:1,child: Container(color: Colors.green,)),

              Container(
                margin: EdgeInsets.only(top: size.height / 2 - size.height / 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        //height: size.height / 3,
                        width: 3 * size.width / 5,
                        child: Image.asset('lib/Asset/firebase-1-logo.png')),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Flutter',
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.amber,
                            decoration: TextDecoration.none),
                      ),
                    ),
                    Text(
                      'FireAuth',
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.orange,
                          decoration: TextDecoration.none),
                    ),
                  ],
                ),
              ),
              _signInButton(),
            ],
          ),
        ),
      ),
    );
  }

  _signInButton() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: GestureDetector(
        onTap: () async {
          setState(() {
            _isSigningIn = true;
          });

          User user = await Authentication.signInWithGoogle(context);

          setState(() {
            _isSigningIn = false;
          });

          if (user != null) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  user,
                ),
              ),
            );
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Image.asset(
            'lib/Asset/google_logo.png',
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
