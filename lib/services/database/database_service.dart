import 'dart:async';

import "package:collection/collection.dart";
import 'package:mobileprism/services/database/album_data_entry.dart';
import 'package:mobileprism/services/database/cross_table_entry.dart';
import 'package:mobileprism/services/database/photo_data_entry.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

const String photoDataTableName = "photo_data";
const String albumDataTableName = "album_data";
const String keyCrosstableName = "key_crosstable";
const String photoTableCreationStrg = '''
      CREATE TABLE IF NOT EXISTS $photoDataTableName(uid TEXT PRIMARY KEY, 
      panorama INTEGER, width INTEGER, height INTEGER,
      image_hash TEXT, image_quality TEXT, lat REAL, long REAL, 
      timestamp INETEGER)
    ''';
const String albumTableCreationStrg = '''
    CREATE TABLE IF NOT EXISTS $albumDataTableName(uid TEXT PRIMARY KEY, 
    photo_uids TEXT, title TEXT, thumb_uid TEXT)
  ''';
const String keyCrosstableCreationStrg = '''
    CREATE TABLE IF NOT EXISTS $keyCrosstableName(photo_uid Text, album_uid Text)
  ''';
// const String databaseConfigString = 'PRAGMA foreign_keys = ON';

late final Database? _database;

class DbNotOpenException implements Exception {}

class FieldsMissingException implements Exception {}

class DuplicateKeyException implements Exception {}

class KeyNotFoundException implements Exception {}

class SqlFilter {
  final String column;
  final String operator;
  final String value;
  final String? comparator;

  const SqlFilter(this.column, this.operator, this.value, {this.comparator});

  @override
  String toString() {
    if (comparator == null) {
      return '("$column" $operator $value)';
    } else {
      return ' $comparator ("$column" $operator $value)';
    }
  }
}

Future<Database> _initDb() async {
  try {
    final dbPath = (await getApplicationDocumentsDirectory()).path;
    return openDatabase(
      join(dbPath, 'meta_data_db.db'),
      onCreate: (db, version) async {
        await _createPhotoDataTable(db);
        await _createAlbumDataTable(db);
      },
      version: 1,
      // onConfigure: (db) async {
      //   await db.execute(databaseConfigString);
      // },
    );
  } on MissingPlatformDirectoryException {
    throw MissingPlatformDirectoryException(
      "Could not get platform directory to create database",
    );
  }
}

Future<void> _createPhotoDataTable(Database db) async {
  await db.execute(
    photoTableCreationStrg,
  );
}

Future<void> _createAlbumDataTable(Database db) async {
  await db.execute(
    albumTableCreationStrg,
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
    return _db != null && _db!.isOpen;
  }

  Database _getOpenDb() {
    if (_db != null && _db!.isOpen) {
      return _db!;
    } else {
      throw DbNotOpenException();
    }
  }

  Future<List<Object?>> _batchInsert(
    String table,
    List<Map<String, dynamic>> dataList,
  ) async {
    final db = _getOpenDb();
    final batch = db.batch();
    for (final data in dataList) {
      batch.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    return batch.commit();
  }

  Future<List<Map<String, Object?>>> _read(
    String table, {
    List<SqlFilter>? filters,
  }) async {
    final db = _getOpenDb();
    if (filters != null) {
      return db.rawQuery('SELECT * FROM $table WHERE ${filters.join()}');
      // return db.query(table, where: filterString, whereArgs: filterValues);
    } else {
      return db.query(table);
    }
  }

  // String assembleFilterString(List<SqlFilter> filters) {
  //   return filters.map((e) => e.toString()).reduce((v, e) => "$v $e");
  // }

  Future<PhotoDataEntry> getPhoto(String id) async {
    final filter = List.filled(1, SqlFilter('uid', '=', '"$id"'));
    final List<Map<String, Object?>> res =
        await _read(photoDataTableName, filters: filter);
    if (res.length == 1) {
      return res.map((e) => PhotoDataEntry.fromMap(e)).first;
    } else if (res.isEmpty) {
      throw KeyNotFoundException();
    } else {
      throw DuplicateKeyException();
    }
  }

  Future<Map<int, Set<int>>> getTimlineAlbums() async {
    final List<Map<String, Object?>> res = await _read(photoDataTableName);
    final Iterable<MapEntry<int, int>> yearMonthTuples = res
        .map((e) => PhotoDataEntry.fromMap(e).timestamp)
        .whereType<int>()
        .map((e) => DateTime.fromMillisecondsSinceEpoch(e * 1000))
        .map((e) => MapEntry(e.year, e.month));

    return groupBy(yearMonthTuples, (MapEntry<int, int> e) => e.key)
        .map((key, value) => MapEntry(key, value.map((e) => e.value).toSet()));
  }

  // [start] / [end]: milliseconds since epoch
  Future<List<PhotoDataEntry>> getPhotosByDateRange(int start, int end) async {
    final String startInSecondsStr = (start ~/ 1000).toString();
    final String endInSecondsStr = (end ~/ 1000).toString();
    final List<SqlFilter> filters = [
      SqlFilter('timestamp', '>=', startInSecondsStr),
      SqlFilter('timestamp', '<=', endInSecondsStr, comparator: "AND")
    ];
    final List<Map<String, Object?>> res =
        await _read(photoDataTableName, filters: filters);
    return res.map((e) => PhotoDataEntry.fromMap(e)).toList();
  }

  Future<List<PhotoDataEntry>> getAlbumPhotos(String albumUid) async {
    final SqlFilter crossTableFilter = SqlFilter('album_uid', '==', albumUid);
    final List<Map<String, Object?>> corssTableRes =
        await _read(keyCrosstableName, filters: [crossTableFilter]);
    final photoUids =
        corssTableRes.map((e) => CrossTableEntry.fromMap(e).photoUid);
    final photoFilters = photoUids
        .map((e) => SqlFilter('uid', '==', e, comparator: "OR"))
        .toList();
    photoFilters[0] = SqlFilter(photoFilters[0].column,
        photoFilters[0].operator, photoFilters[0].value,);
    final photoRes = await _read(photoDataTableName, filters: photoFilters);
    return photoRes.map((e) => PhotoDataEntry.fromMap(e)).toList();
  }

  Future<List<AlbumDataEntry>> getAlbums() async {
    final List<Map<String, Object?>> res = await _read(albumDataTableName);
    return res.map((e) => AlbumDataEntry.fromMap(e)).toList();
  }

  Future<List<PhotoDataEntry>> getAllPhotos() async {
    final List<Map<String, Object?>> res = await _read(photoDataTableName);
    return res.map((e) => PhotoDataEntry.fromMap(e)).toList();
  }

  Future<List<Object?>> insertPhotos(
    List<PhotoDataEntry> photoDataEntrys,
  ) async {
    final dataList = photoDataEntrys.map((e) => e.toMap()).toList();
    return _batchInsert(photoDataTableName, dataList);
  }

  Future<List<Object?>> insertAlbums(List<AlbumDataEntry> albumDataEntrys) {
    final dataList = albumDataEntrys.map((e) => e.toMap()).toList();
    return _batchInsert(albumDataTableName, dataList);
  }

  Future<List<Object?>> addPhotoUidsToAlbum(
    String albumUid,
    List<String> photoUids,
  ) {
    final dataList = photoUids
        .map((e) => CrossTableEntry(albumUid: albumUid, photoUid: e).toMap())
        .toList();
    return _batchInsert(keyCrosstableName, dataList);
  }
}
