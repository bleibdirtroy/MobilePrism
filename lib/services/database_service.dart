import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final Future<Database> _database = _initDb();

Future<Database> _initDb() async {
  try{
    final dbPath = (await getApplicationDocumentsDirectory()).path;
    return openDatabase(
    join(dbPath, 'meta_data_db.db'),
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE IF NOT EXISTS album_data(album_uid TEXT PRIMARY KEY, 
          photo_uids TEXT, title TEXT, thumb_uid TEXT)
        ''',);
        return db.execute('''
          CREATE TABLE IF NOT EXISTS photo_data(uid TEXT PRIMARY KEY, 
          panorama INTEGER, width INTEGER, heigth INTEGER,
          image_hash TEXT, image_quality TEXT, lat REAL, long REAL, 
          timestamp INETEGER)
        ''',);
        },
        version: 1,
      );   
  } on MissingPlatformDirectoryException {
    throw MissingPlatformDirectoryException("Could not get platform directory to create database");
  }
}

Future<bool> isOpen () async{
  return (await _database).isOpen;
}

Future<void> executeQuery(String query) async {
  final db = await _database;
  db.execute(query,);
}
