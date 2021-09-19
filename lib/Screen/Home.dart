import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zupayAssignment/Models/MoviesListTile.dart';
import 'package:zupayAssignment/Service/DataBase.dart';
import 'package:zupayAssignment/Screen/AddMovie.dart';

class Home extends StatefulWidget {
  final user;
  Home(this.user);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            _movieTileBuilder(),
            //_movieList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Permission p = Permission.storage;
          if (await p.isGranted) {
            Navigator.push(context,
                MaterialPageRoute(builder: (ctx) => AddMovie(widget.user.uid)));
          }
        },
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  _movieCard(MoviesListTile tile) {
    return Container(
      width: size.width - 20,
      height: 150,
      child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        15), //BorderRadius.only(topLeft:Radius.circular(15), bottomLeft: Radius.circular(15)),
                    child: Image.asset('lib/Asset/login_background.jpg',
                        fit: BoxFit.cover)),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bahubali',
                      style: TextStyle(fontSize: 40),
                    ),
                    Text(
                      'Cp Palli',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.delete,
                    size: 30,
                  ),
                  onPressed: null)
            ],
          )),
    );
  }

  _movieTileBuilder() {
    return Container(
      child: Expanded(
        child: StreamBuilder(
            stream: DataBase(widget.user.uid).readMovieList(),
            builder: (ctx, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                var tiles = snapshot.data.toList;
                return ListView.builder(
                  itemCount: tiles.length ?? 0,
                  itemBuilder: (ctx, i) {
                    return Card(
                      child: ListTile(
                        title: Text(tiles[i]['name']),
                        subtitle: Text(tiles[i]['director']),
                      ),
                    );
                  },
                );
              }

              if (!snapshot.hasData) {
                return Text('No movie added yet');
              } else {
                return Text('null h ji');
              }
            }),
      ),
    );
  }

  _topBar() {
    return Container(
      color: Colors.blue,
      width: size.width,
      height: 80,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              child: Image.network(widget.user.photoURL),
            ),
            Column(
              children: [
                Text('Welcome'),
                Text('${widget.user.displayName}'),
              ],
            )
          ],
        ),
      ),
    );
  }
  // _movieList() {
  //   return Expanded(
  //     child: ListView.builder(
  //         itemCount: 1,
  //         itemBuilder: (ctx, i) {
  //           Container(
  //             width: size.width,
  //             height: 100,
  //             child: Card(
  //                 child: Container(
  //               child: Row(
  //                 children: [
  //                   Image.network(mlst[i].img),
  //                   Column(
  //                     children: [
  //                       Expanded(child: Text('${mlst[i].name}')),
  //                       Expanded(child: Text('${mlst[i].director}')),
  //                     ],
  //                   )
  //                 ],
  //               ),
  //             )),
  //           );
  //         }),
  //   );
  // }
}
