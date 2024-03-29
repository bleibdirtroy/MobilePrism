import 'dart:collection';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:mobileprism/generated/objectbox.g.dart';
import 'package:mobileprism/models/album_data_entry.dart';
import 'package:mobileprism/models/photo_data_entry.dart';
import 'package:mobileprism/models/timeline_data_entry.dart';
import 'package:mobileprism/services/database/database_exceptions.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

late final Store _store;

Future<bool> createStore({String? testDbPath}) async {
  if (testDbPath == null) {
    final Directory dir = await getApplicationSupportDirectory();
    _store = await openStore(directory: join(dir.path, "objectBox"));
    return !_store.isClosed();
  } else {
    _store = await openStore(directory: testDbPath);
    return !_store.isClosed();
  }
}

class DatabaseService {
  late final Store _db;

  DatabaseService() {
    _db = _store;
  }

  bool isOpen() {
    return !_db.isClosed();
  }

  void deleteDbContent() {
    _db.box<AlbumDataEntry>().removeAll();
    _db.box<PhotoDataEntry>().removeAll();
    _db.box<TimelineDataEntry>().removeAll();
  }

  Map<int, SplayTreeSet<int>> getTimlineAlbums() {
    final List<TimelineDataEntry> timlineAlbums =
        _db.box<TimelineDataEntry>().getAll();
    return groupBy(timlineAlbums, (TimelineDataEntry e) => e.year).map(
      (key, value) => MapEntry<int, SplayTreeSet<int>>(
        key,
        SplayTreeSet.from(value.map((e) => e.month)),
      ),
    );
  }

  List<AlbumDataEntry> getAlbums() {
    return _db.box<AlbumDataEntry>().getAll();
  }

  List<PhotoDataEntry> getAlbumPhotos(String albumUid) {
    final query = _db
        .box<AlbumDataEntry>()
        .query(AlbumDataEntry_.uid.equals(albumUid))
        .build();
    final albumRes = query.findFirst();
    query.close();
    final albumPhotos = albumRes != null
        ? albumRes.albumPhotos
        : throw AlbumNotFoundException();
    return albumPhotos.toList();
  }

  List<PhotoDataEntry> getPhotosByDateRange(int start, int end) {
    final query = _db
        .box<PhotoDataEntry>()
        .query(PhotoDataEntry_.timestamp.between(start, end))
        .build();
    final photosRes = query.find();
    query.close();
    return photosRes.toList();
  }

  List<int> insertPhotos(
    List<PhotoDataEntry> photoDataEntrys,
  ) {
    final storedImages = _db.box<PhotoDataEntry>().getAll();
    final uidsToInsert = photoDataEntrys.map((e) => e.uid);
    final idsToRemove = storedImages
        .where((e) => uidsToInsert.contains(e.uid))
        .map((e) => e.id)
        .toList();
    _db.box<PhotoDataEntry>().removeMany(idsToRemove);
    return _db.box<PhotoDataEntry>().putMany(photoDataEntrys);
  }

  List<int> insertAlbums(List<AlbumDataEntry> albumDataEntrys) {
    _db.box<AlbumDataEntry>().removeAll();
    return _db.box<AlbumDataEntry>().putMany(albumDataEntrys);
  }

  List<int> insertTimelineAlbums(
    List<TimelineDataEntry> timelineDataEntrys,
  ) {
    _db.box<TimelineDataEntry>().removeAll();
    return _db.box<TimelineDataEntry>().putMany(timelineDataEntrys);
  }

  int addPhotoUidsToAlbum(
    String albumUid,
    List<String> photoUids,
  ) {
    final albumPhotos = _db
        .box<PhotoDataEntry>()
        .getAll()
        .where((e) => photoUids.contains(e.uid));
    final storedTimelineAlbum =
        _db.box<TimelineDataEntry>().getAll().where((e) => e.uid == albumUid);
    final storedAlbum =
        _db.box<AlbumDataEntry>().getAll().where((e) => e.uid == albumUid);

    if (storedTimelineAlbum.isNotEmpty) {
      final timelineAblum = storedTimelineAlbum.first;
      timelineAblum.timelinePhotos.clear();
      timelineAblum.timelinePhotos.addAll(albumPhotos);
      return _db.box<TimelineDataEntry>().put(timelineAblum);
    } else if (storedAlbum.isNotEmpty) {
      final album = storedAlbum.first;
      album.albumPhotos.clear();
      album.albumPhotos.addAll(albumPhotos);
      return _db.box<AlbumDataEntry>().put(album);
    } else {
      throw AlbumNotFoundException();
    }
  }

  int removeUnlinkedPhotos() {
    final albumUids =
        _db.box<TimelineDataEntry>().getAll().map((e) => e.uid).toList();
    albumUids
        .addAll(_db.box<AlbumDataEntry>().getAll().map((e) => e.uid).toList());
    final unlinkedPhotosIds = _db
        .box<PhotoDataEntry>()
        .getAll()
        .where((e) => !albumUids.contains(e.uid))
        .toList()
        .map((e) => e.id)
        .toList();
    return _db.box<PhotoDataEntry>().removeMany(unlinkedPhotosIds);
  }
}
