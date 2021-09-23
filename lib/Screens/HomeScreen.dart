import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final user;
  HomeScreen(this.user);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hi User ${widget.user.displayName}"),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              child: Image.network(widget.user.photoURL),
            ),
            Text("This is your homePage"),
          ],
        ),
      ),
    );
  }
}
