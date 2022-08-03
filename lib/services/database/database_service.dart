import 'dart:async';

// import 'package:mobileprism/services/database/album_data_entry.dart';
// import 'package:mobileprism/services/database/photo_data_entry.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

late final Database? _database;

class DbNotOpenException implements Exception {}

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
      "Could not get platform directory to create database",
    );
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
  late final Database? _db;

  DatabaseService();

  DatabaseService.test(this._db);

  Future<bool> openDB() async {
    _db = await _openDb();
    return _db!.isOpen;
  }

  // Database _getOpenDb() {
  //   if (_db != null && _db!.isOpen) {
  //     return _db!;
  //   } else {
  //     throw DbNotOpenException();
  //   }
  // }

  // Future<void> _delete(String id, String table) async {
  //   final db = _getOpenDb();
  // }

  // Future<void> _insert(String table) async {
  //   final db = _getOpenDb();
  // }

  // Future<void> _update(String id, String table) async {
  //   final db = _getOpenDb();
  // }

  // Future<void> _read(String id, String table) async {
  //   final db = _getOpenDb();
  // }

  // Future<PhotoDataEntry> getPhoto(String photoId);

  // Future<List<Map<int, int>> getTimlineAlbums();

  // Future<List<PhotoDataEntry>> getPhotosByDateRange(int start, int end);

  // Future<List<PhotoDataEntry>> getAlbumPhotos(String albumId);

  // Future<List<AlbumDataEntry>> getAlbums();

  // Future<List<PhotoDataEntry>> getAllPhotos();

  // Future<void> insertPhotos(List<PhotoDataEntry> photoDataEntrys);

  // Future<void> insertAlbums(List<PhotoDataEntry> photoDataEntrys);

}
