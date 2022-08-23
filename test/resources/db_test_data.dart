import 'package:mobileprism/services/database/album_data_entry.dart';
import 'package:mobileprism/services/database/photo_data_entry.dart';
import 'package:mobileprism/services/database/timeline_data_entry.dart';

final testAlbum1 = AlbumDataEntry(
  uid: "1",
  title: "title",
  thumbHash: "1",
);
final testAlbum2 = AlbumDataEntry(uid: "2", title: "title", thumbHash: "2");

final timelineData1 = TimelineDataEntry(uid: "3", year: 2022, month: 8);
final timelineData2 = TimelineDataEntry(uid: "4", year: 2022, month: 9);

final testPhoto1 = PhotoDataEntry(
  uid: "1",
  panorama: true,
  height: 1,
  width: 10,
  lat: 35.87,
  long: 40,
  imageHash: "hash",
  imageQuality: "high_qal",
  timestamp: 1650012700,
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
  timestamp: 1660512800,
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
  timestamp: 1560512900,
);
