import 'package:mobileprism/models/photo_data_entry.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class AlbumDataEntry {
  int id;
  @Unique()
  final String uid;
  final String title;
  final String thumbHash;
  @Backlink('normalAlbums')
  final albumPhotos = ToMany<PhotoDataEntry>();

  AlbumDataEntry({
    this.id = 0,
    required this.uid,
    required this.title,
    required this.thumbHash,
  });

  AlbumDataEntry.fromJson(Map<String, dynamic> json)
      : id = 0,
        uid = json["UID"] as String,
        title = json["Title"] as String,
        thumbHash = json["Thumb"].toString();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is AlbumDataEntry &&
        other.uid == uid &&
        other.title == title &&
        other.thumbHash == thumbHash;
  }

  @override
  int get hashCode => Object.hash(uid, title, thumbHash);
}
