import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobileprism/services/database/database_exceptions.dart';
import 'package:mobileprism/services/database/database_service.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../resources/db_test_data.dart';

void main() async {
  sqfliteFfiInit();
  final Database db =
      await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
  db.execute(photoTableCreationStrg);
  db.execute(albumTableCreationStrg);
  db.execute(keyCrosstableCreationStrg);
  db.execute(timelineTableCreationStrg);
  final DatabaseService dbService = DatabaseService.test(db);

  Future<void> deleteAllEntries() async {
    await db.rawDelete("DELETE FROM $photoDataTableName");
    await db.rawDelete("DELETE FROM $albumDataTableName");
  }

  test('Test setting up db', () async {
    expect(await db.getVersion(), 0);
    expect(db.isOpen, true);
  });

  test('Test database service setup', () async {
    expect(dbService.isOpen(), true);
  });

  test('Test writing albums', () async {
    await deleteAllEntries();
    final res =
        await dbService.insertAlbums([testAlbum1, testAlbum1, testAlbum2]);
    expect(res.length, 3);
  });

  test('Test writing photos', () async {
    await deleteAllEntries();
    final res = await dbService.insertPhotos([testPhoto1, testPhoto2]);
    expect(res.length, 2);
  });

  test('Test writing timeline albums', () async {
    await deleteAllEntries();
    final res =
        await dbService.insertTimelineAlbums([timelineData1, timelineData2]);
    expect(res.length, 2);
  });

  test('Test reading albums', () async {
    await deleteAllEntries();
    await dbService.insertAlbums([testAlbum1, testAlbum2]);
    final res = await dbService.getAlbums();
    expect(res[0].uid, testAlbum1.uid);
    expect(res[1].uid, testAlbum2.uid);
  });

  test('Test reading one photo', () async {
    await deleteAllEntries();
    await dbService.insertPhotos([testPhoto1, testPhoto2]);
    final res = await dbService.getPhoto("1");
    expect(res.uid, "1");

    expect(
      () => dbService.getPhoto("3"),
      throwsA(const TypeMatcher<KeyNotFoundException>()),
    );
  });

  test('Test reading all photos', () async {
    await deleteAllEntries();
    await dbService.insertPhotos([testPhoto1, testPhoto2]);
    final res = await dbService.getAllPhotos();
    expect(res.length, 2);
    expect(res.map((e) => e.uid).contains("1"), true);
    expect(res.map((e) => e.uid).contains("2"), true);
  });

  test('Test add photos to album', () async {
    await deleteAllEntries();
    await dbService.insertAlbums([testAlbum1]);
    await dbService.insertPhotos([testPhoto1, testPhoto2]);

    final res = await dbService.addPhotoUidsToAlbum("1", ["1", "2"]);
    expect(res.length, 2);
  });

  test('Test get photos of album', () async {
    await deleteAllEntries();
    await dbService.insertAlbums([testAlbum1]);
    await dbService.insertPhotos([testPhoto1, testPhoto2, testPhoto3]);
    await dbService.addPhotoUidsToAlbum("1", ["1", "2"]);

    final res = await dbService.getAlbumPhotos("1");
    expect(res.map((e) => e.uid).contains("1"), true);
    expect(res.map((e) => e.uid).contains("2"), true);
  });

  test('Test get timeline albums', () async {
    await deleteAllEntries();
    await dbService
        .insertTimelineAlbums([timelineData1, timelineData2, timelineData3]);

    final res = await dbService.getTimlineAlbums();
    final Map<int, Set<int>> expectedRes = {
      2022: {4, 9},
      2019: {6}
    };
    expect(const DeepCollectionEquality().equals(res, expectedRes), true);
  });

  test('Test get photos by date range', () async {
    await deleteAllEntries();
    await dbService.insertPhotos([testPhoto1, testPhoto2, testPhoto3]);
    final dateNow = DateTime.now();
    final dateOld = DateTime(2020);

    final res = await dbService.getPhotosByDateRange(
      dateOld.millisecondsSinceEpoch,
      dateNow.millisecondsSinceEpoch,
    );
    expect(res.map((e) => e.uid).contains("1"), true);
    expect(res.map((e) => e.uid).contains("2"), true);
  });
}
