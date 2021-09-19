import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zupayAssignment/Models/MoviesListTile.dart';
import 'package:zupayAssignment/Service/DataBase.dart';

class AddMovie extends StatefulWidget {
  final uid;
  AddMovie(this.uid);
  @override
  _AddMovieState createState() => _AddMovieState();
}

class _AddMovieState extends State<AddMovie> {
  File _poster;
  TextEditingController _movieName = TextEditingController();
  TextEditingController _directorName = TextEditingController();
  ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add movie'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _movieName,
                  decoration: InputDecoration(
                      labelText: 'Movie Name',
                      hintText: 'eg: Bahubali',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _directorName,
                  decoration: InputDecoration(
                      labelText: 'Director Name',
                      hintText: 'eg: Rohit Shetty',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              _poster == null
                  ? GestureDetector(
                      onTap: () async {
                        await _pickImage();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.withOpacity(0.5)),
                        width: 100,
                        height: 100,
                        child: Center(
                          child: Text('Add Poster'),
                        ),
                      ),
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      child: Image.file(
                        _poster,
                        fit: BoxFit.cover,
                      ),
                    ),
              RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () async {
                    _poster != null
                        ? _submit()
                        : print('plese fill all detailes');
                  },
                  color: Colors.blueAccent,
                  child: Text(
                    'AddMovie',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  _submit() {
    var tile = MoviesListTile(
        name: _movieName.text,
        director: _directorName.text,
        posterImg: _poster.path);
    DataBase(widget.uid).createList(tile);
  }

  Future<void> _pickImage() async {
    //do something
    var a = await _picker.getImage(source: ImageSource.gallery);
    _poster = File(a.path);
    setState(() {});
  }
}
