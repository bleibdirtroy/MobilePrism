import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobileprism/models/album_data_entry.dart';
import 'package:mobileprism/models/photo_data_entry.dart';
import 'package:mobileprism/services/database/database_service.dart';
import 'package:path/path.dart';

import '../../resources/db_test_data.dart';

void main() async {
  final testDbPath = join(Directory.current.path, "test", "objectbox");
  await Directory(testDbPath).create(recursive: true);
  await Directory(testDbPath).delete(recursive: true);
  await createStore(testDbPath: testDbPath);
  final DatabaseService dbService = DatabaseService();

  tearDown(() {
    dbService.deleteDbContent();
  });

  test('Test createStore', () async {
    expect(dbService.isOpen(), true);
  });

  test('Test getTimelineAlbums and insertTimelineAlbums', () async {
    dbService.insertTimelineAlbums(
      [testTimelineData1, testTimelineData2, testTimelineData3],
    );
    final res = dbService.getTimlineAlbums();
    final Map<int, Set<int>> expectedRes = {
      2022: {4, 9},
      2019: {6}
    };
    expect(const DeepCollectionEquality().equals(res, expectedRes), true);
  });

  test('Test getAlbums and insertAlbums', () async {
    dbService.insertAlbums([testAlbum1, testAlbum2]);
    final res = dbService.getAlbums();
    final List<AlbumDataEntry> expectedRes = [testAlbum1, testAlbum2];
    expect(const DeepCollectionEquality().equals(res, expectedRes), true);
  });

  test('Test getAlbumPhotos and addPhotoUidsToAlbum', () async {
    dbService.insertAlbums([testAlbum1, testAlbum2]);
    dbService.insertPhotos([testPhoto1, testPhoto2, testPhoto3]);
    dbService.addPhotoUidsToAlbum("1", ["1", "2", "3"]);
    final res = dbService.getAlbumPhotos("1");
    final List<PhotoDataEntry> expectedRes = [
      testPhoto1,
      testPhoto2,
      testPhoto3
    ];
    expect(const DeepCollectionEquality().equals(res, expectedRes), true);
  });

  test('Test getPhotosByDateRange', () async {
    dbService.insertPhotos([testPhoto1, testPhoto2, testPhoto3]);
    final dateNow = DateTime.now();
    final dateOld = DateTime(2020);

    final res = dbService.getPhotosByDateRange(
      dateOld.millisecondsSinceEpoch,
      dateNow.millisecondsSinceEpoch,
    );
    expect(res.map((e) => e.uid).contains("1"), true);
    expect(res.map((e) => e.uid).contains("2"), true);
  });

  test('Test insertPhotos', () async {
    final res = dbService.insertPhotos([testPhoto1, testPhoto2, testPhoto3]);
    final List<int> expectedRes = [1, 2, 3];
    expect(const DeepCollectionEquality().equals(res, expectedRes), true);
  });

  test('Test removeUnlinkedPhotos', () async {
    dbService.insertPhotos([testPhoto1, testPhoto2, testPhoto3]);
    dbService.insertAlbums([testAlbum1, testAlbum2]);
    dbService.addPhotoUidsToAlbum("1", ["1"]);
    dbService.addPhotoUidsToAlbum("2", ["2"]);
    dbService.removeUnlinkedPhotos();
    final res1 = dbService.getAlbumPhotos("1");
    final res2 = dbService.getAlbumPhotos("2");
    final List<PhotoDataEntry> expectedRes1 = [testPhoto1];
    final List<PhotoDataEntry> expectedRes2 = [testPhoto2];
    expect(const DeepCollectionEquality().equals(res1, expectedRes1), true);
    expect(const DeepCollectionEquality().equals(res2, expectedRes2), true);
  });
}
