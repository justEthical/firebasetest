import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:zupayAssignment/Models/MoviesListTile.dart';

class DataBase {
  final uid;
  DataBase(this.uid);

  final CollectionReference movieList =
      FirebaseFirestore.instance.collection('movieList');

  Future createList(MoviesListTile moviesListTile) async {
    String _posterImg = await _uploadImage(File(moviesListTile.posterImg));
    var movieTile = movieList.doc(uid).collection('Tile');
    Map<String, dynamic> data = {
      'name': moviesListTile.name,
      'director': moviesListTile.director,
      'posterImg': _posterImg,
      'id': movieTile.id,
    };
    await movieTile.add(data);
  }

  Stream readMovieList() {
    var a = movieList.doc(uid).collection('Tile').snapshots();
    
    return a;
  }

  fromJason(Map<String, dynamic> json) {
    return MoviesListTile(
        name: json['name'],
        director: json['director'],
        posterImg: json['posterImg']);
  }

  Future<String> _uploadImage(File poster) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('/MoviePoster/${Path.basename(poster.path)}}');
    UploadTask uploadTask = storageReference.putFile(poster);
    await uploadTask.whenComplete(() => print('file uploaded'));
    String url = await storageReference.getDownloadURL();
    return url;
  }
}
