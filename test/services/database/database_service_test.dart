import 'package:flutter_test/flutter_test.dart';
import 'package:mobileprism/services/database/database_service.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'database_test_data.dart';


void main() async {
  sqfliteFfiInit();
  final Database db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
  db.execute(photoTableCreationStrg);
  db.execute(albumTableCreationStrg);
  db.execute(keyCrosstableCreationStrg);
  final DatabaseService dbService = DatabaseService.test(db);

  test('Test setting up db', () async {
    expect(await db.getVersion(), 0);
    expect(db.isOpen, true);
  });

  test('Test database service setup', () async {
    expect(dbService.isOpen(), true);
  });
  
  test('Test writing albums', () async {
    final res = await dbService.insertAlbums([testAlbum1, testAlbum1, testAlbum2]);
    expect(res.length, 3);
  });

  test('Test writing photos', () async {
    final res = await dbService.insertPhotos([testPhoto1, testPhoto2]);
    expect(res.length, 2);
  });
}
