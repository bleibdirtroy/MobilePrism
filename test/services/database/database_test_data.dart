import 'package:mobileprism/services/database/album_data_entry.dart';
import 'package:mobileprism/services/database/photo_data_entry.dart';

final testAlbum1 = AlbumDataEntry(uid: "1", title: "title", thumbUid: "thumbUid");
final testAlbum2 = AlbumDataEntry(uid: "2", title: "title", thumbUid: "thumbUid");
final testPhoto1 = PhotoDataEntry(uid: "1", panorama: true, 
  height: 1, 
  width: 10, 
  lat: 35.87, 
  long: 40, 
  imageHash: "hash", 
  imageQuality: "high_qal", 
  timestamp: 13128372398473,);
final testPhoto2 = PhotoDataEntry(uid: "2", panorama: true, 
  height: 1, 
  width: 10, 
  lat: 35.87, 
  long: 40, 
  imageHash: "hash", 
  imageQuality: "high_qal", 
  timestamp: 13128372398473,);
