import 'package:mobileprism/models/album_data_entry.dart';
import 'package:mobileprism/models/cross_table_entry.dart';
import 'package:mobileprism/models/photo_data_entry.dart';
import 'package:mobileprism/models/timeline_data_entry.dart';

const List<Map<String, dynamic>> rawDbAlbumResponse = [
  {"uid": "1", "title": "title", "thumb_hash": "1"},
  {"uid": "2", "title": "title", "thumb_hash": "2"}
];

const List<Map<String, dynamic>> rawDbTimlineResponse = [
  {"uid": "10", "year": 1, "month": 1},
  {"uid": "11", "year": 2, "month": 2}
];

const List<Map<String, dynamic>> rawDbPhotoResponse = [
  {
    "uid": 1,
    "panorama": "1",
    "width": 10,
    "height": 1,
    "image_hash": "hash",
    "image_quality": "high_qal",
    "lat": 35.87,
    "long": 40.0,
    "timestamp": 1650012700000
  },
  {
    "uid": "2",
    "panorama": 1,
    "width": 10,
    "height": 1,
    "image_hash": "hash",
    "image_quality": "high_qal",
    "lat": 35.87,
    "long": 40.0,
    "timestamp": 1660512800000
  }
];

const List<Map<String, dynamic>> rawDbCrosstableResponse = [
  {"photo_uid": "1", "album_uid": "1"},
  {"photo_uid": "2", "album_uid": "1"}
];

final testAlbum1 = AlbumDataEntry(
  uid: "1",
  title: "title",
  thumbHash: "1",
);
final testAlbum2 = AlbumDataEntry(
  uid: "2",
  title: "title",
  thumbHash: "2",
);

final timelineData1 = TimelineDataEntry(uid: "3", year: 2019, month: 6);
final timelineData2 = TimelineDataEntry(uid: "4", year: 2022, month: 4);
final timelineData3 = TimelineDataEntry(uid: "5", year: 2022, month: 9);

final testPhoto1 = PhotoDataEntry(
  uid: "1",
  panorama: true,
  height: 1,
  width: 10,
  lat: 35.87,
  long: 40,
  imageHash: "hash",
  imageQuality: "high_qal",
  timestamp: 1650012700000,
);
final testPhoto2 = PhotoDataEntry(
  uid: "2",
  panorama: true,
  height: 1,
  width: 10,
  lat: 35.87,
  long: 40,
  imageHash: "hash",
  imageQuality: "high_qal",
  timestamp: 1660512800000,
);
final testPhoto3 = PhotoDataEntry(
  uid: "3",
  panorama: true,
  height: 2,
  width: 20,
  lat: 1,
  long: 2,
  imageHash: "hash",
  imageQuality: "high_qal",
  timestamp: 1560512900000,
);

// final crossTableData1 = CrossTableEntry(albumUid: "20", photoUid: "1");
// final crossTableData2 = CrossTableEntry(albumUid: "21", photoUid: "2");
