import 'dart:async';

import "package:collection/collection.dart";
import 'package:mobileprism/services/database/album_data_entry.dart';
import 'package:mobileprism/services/database/photo_data_entry.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

const String photoDataTableName = "photo_data";
const String albumDataTableName = "album_data";

late final Database? _database;

class DbNotOpenException implements Exception {}

class FieldsMissingException implements Exception {}

class DuplicateKeyException implements Exception {}

class SqlFilter {
  final String column;
  final String operator;
  final String value;
  final String? comparator;

  const SqlFilter(this.column, this.operator, this.value, {this.comparator});

  @override
  String toString() {
    if (comparator == null){
      return '("$column" $operator ?)';
    }
    else {
      return ' $comparator ("$column" $operator ?)';
    }
  }
}

Future<Database> _initDb() async {
  try {
    final dbPath = (await getApplicationDocumentsDirectory()).path;
    return openDatabase(
      join(dbPath, 'meta_data_db.db'),
      onCreate: (db, version) async {
        createPhotoDataTable(db);
        createAlbumDataTable(db);
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

Future<void> createPhotoDataTable(Database db) async {
  await db.execute(
    '''
    CREATE TABLE IF NOT EXISTS $photoDataTableName(uid TEXT PRIMARY KEY, 
    panorama INTEGER, width INTEGER, heigth INTEGER,
    image_hash TEXT, image_quality TEXT, lat REAL, long REAL, 
    timestamp INETEGER)
  ''',
  );
}

Future<void> createAlbumDataTable(Database db) async {
  await db.execute(
    '''
      CREATE TABLE IF NOT EXISTS $albumDataTableName(uid TEXT PRIMARY KEY, 
      photo_uids TEXT, title TEXT, FOREIGN KEY(thumb_uid) REFERENCES photo_data(uid))
    ''',
  );
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

  bool isOpen() {
    if (_db != null && _db!.isOpen) {
      return true;
    } else {
      return false;
    }
  }

  Database _getOpenDb() {
    if (_db != null && _db!.isOpen) {
      return _db!;
    } else {
      throw DbNotOpenException();
    }
  }

  // Future<int> _delete(String table, String id) async {
  //   final db = _getOpenDb();
  //   return db.delete(
  //     table,
  //     where: '"uid" = ?',
  //     whereArgs: [id],
  //   );
  // }

  // Future<int> _insert(String table, Map<String, dynamic> data) async {
  //   final db = _getOpenDb();
  //   return db.insert(
  //     table,
  //     data,
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

  // Future<int> _update(
  //     String table, String id, Map<String, dynamic> data) async {
  //   final db = _getOpenDb();
  //   return db.update(
  //     table,
  //     data,
  //     where: '"uid" = ?',
  //     whereArgs: [id],
  //   );
  // }

  Future<List<Object?>> _batchInsert (String table, List<Map<String, dynamic>> dataList) async {
    final db = _getOpenDb();
    final batch = db.batch();
    for (final data in dataList){
      batch.insert(photoDataTableName, data);
    }
    return batch.commit();
  }

  Future<List<Map<String, Object?>>> _read(String table,
      {List<SqlFilter>? filters}) async {
    final db = _getOpenDb();
    if (filters != null) {
      final filterString = assembleFilterString(filters);
      final filterValues = filters.map((e) => e.operator).toList();
      return db.query(table, where: filterString, whereArgs: filterValues);
    } else {
      return db.query(table);
    }
  }

  String assembleFilterString(List<SqlFilter> filters) {
    return filters.map((e) => e.toString()).reduce((v, e) => "$v $e");
  }

  Future<PhotoDataEntry> getPhoto(String id) async {
    final filter = List.filled(1, SqlFilter('uid', '=', id));
    final List<Map<String, Object?>> res =
        await _read(photoDataTableName, filters: filter);
    if (res.length == 1) {
      return res.map((e) => PhotoDataEntry.fromMap(e)).first;
    } 
    else {throw DuplicateKeyException();}
  }

  Future<Map<int, Set<int>>> getTimlineAlbums() async {
    final List<Map<String, Object?>> res = await _read(photoDataTableName);
    final Iterable<MapEntry<int, int>> yearMonthTuples = res
        .map(
          (e) => {
            if (e["timestamp"] != null) {e["timestamp"]! as int} else {null}
          },
        )
        .whereType<int>()
        .map((e) => DateTime.fromMillisecondsSinceEpoch(e * 1000))
        .map((e) => MapEntry(e.year, e.month));

    return groupBy(yearMonthTuples, (MapEntry<int, int> e) => e.key)
        .map((key, value) => MapEntry(key, value.map((e) => e.key).toSet()));
  }

  Future<List<PhotoDataEntry>> getPhotosByDateRange(int start, int end) async {
    final List<SqlFilter> filters = [SqlFilter('timestamp', '>=', start as String), 
      SqlFilter('timestamp', '=<', end as String, comparator: "AND")];
    final List<Map<String, Object?>> res = await _read(photoDataTableName, filters: filters);
    return res.map((e) => PhotoDataEntry.fromMap(e)).toList();
  }

  Future<List<PhotoDataEntry>> getAlbumPhotos(String albumId) async {
    final List<SqlFilter> albumFilter = [SqlFilter('uid', '>=', albumId)];
    final List<Map<String, Object?>> albumRes = await _read(albumDataTableName, filters: albumFilter);
    final albumDataList = albumRes.map((e) => AlbumDataEntry.fromMap(e)).toList();
    if (albumDataList.length ==  1){
      final albumEntry = albumDataList.first;
      if (albumEntry.photoUids != null){
        final List<String> photoUids = albumEntry.photoUids!;
        final String listString = "(${photoUids.reduce((v, e) => "$v, $e")})";
        final photoFilter = [SqlFilter("uid", "IN", listString)];
        final photoRes = await _read(photoDataTableName, filters: photoFilter);
        return photoRes.map((e) => PhotoDataEntry.fromMap(e)).toList();
      }
      else {
        throw FieldsMissingException();
      }
    }
    else {throw DuplicateKeyException();}
  }

  Future<List<AlbumDataEntry>> getAlbums() async {
    final List<Map<String, Object?>> res = await _read(albumDataTableName);
    return res.map((e) => AlbumDataEntry.fromMap(e)).toList();
  }

  Future<List<PhotoDataEntry>> getAllPhotos() async {
    final List<Map<String, Object?>> res = await _read(photoDataTableName);
    return res.map((e) => PhotoDataEntry.fromMap(e)).toList();
  }

  Future<List<Object?>> insertPhotos(List<PhotoDataEntry> photoDataEntrys) async {
    final dataList = photoDataEntrys.map((e) => e.toMap()).toList();
    return _batchInsert(photoDataTableName, dataList);
  }

  Future<List<Object?>> insertAlbums(List<AlbumDataEntry> albumDataEntrys){
    final dataList = albumDataEntrys.map((e) => e.toMap()).toList();
    return _batchInsert(albumDataTableName, dataList);
  }
}
