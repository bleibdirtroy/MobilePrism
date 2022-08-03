import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

late final Database? _database;

Future<Database> _initDb() async {
  try {
    final dbPath = (await getApplicationDocumentsDirectory()).path;
    return openDatabase(
      join(dbPath, 'meta_data_db.db'),
      onCreate: (db, version) {
        db.execute(
          '''
          CREATE TABLE IF NOT EXISTS photo_data(uid TEXT PRIMARY KEY, 
          panorama INTEGER, width INTEGER, heigth INTEGER,
          image_hash TEXT, image_quality TEXT, lat REAL, long REAL, 
          timestamp INETEGER)
        ''',
        );
        return db.execute(
          '''
          CREATE TABLE IF NOT EXISTS album_data(album_uid TEXT PRIMARY KEY, 
          photo_uids TEXT, title TEXT, FOREIGN KEY(thumb_uid) REFERENCES photo_data(uid))
        ''',
        );
      },
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  } on MissingPlatformDirectoryException {
    throw MissingPlatformDirectoryException(
        "Could not get platform directory to create database");
  }
}

Future<Database> _openDb() async {
  if (_database == null) {
    _database = await _initDb();
  } else if (!_database!.isOpen) {
    _database = await _initDb();
  }
  return _database!;
}

class DatabaseService {
  late final Future<Database> _databaseRef;

  DatabaseService() {
    _databaseRef = _openDb();
  }

  DatabaseService.test(this._databaseRef);

  Future<bool> isOpen() async {
    final db = await _databaseRef;
    return db.isOpen;
  }

  Future<void> executeQuery(String query) async {
    final db = await _databaseRef;
    db.execute(
      query,
    );
  }
}
