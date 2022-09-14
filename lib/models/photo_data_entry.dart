// @JsonSerializable(fieldRename: FieldRename.snake)
import 'package:mobileprism/models/album_data_entry.dart';
import 'package:mobileprism/models/timeline_data_entry.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class PhotoDataEntry {
  int id;
  @Unique()
  final String uid;
  final bool? panorama;
  final int? width;
  final int? height;
  final String? imageHash;
  final String? imageQuality;
  final double? lat;
  final double? long;
  final int? timestamp;
  final timlineAlbum = ToOne<TimelineDataEntry>();
  final normalAlbums = ToMany<AlbumDataEntry>();

  PhotoDataEntry({
    this.id = 0,
    required this.uid,
    this.panorama,
    this.width,
    this.height,
    this.imageHash,
    this.imageQuality,
    this.lat,
    this.long,
    this.timestamp,
  });

  PhotoDataEntry.fromJson(Map<String, dynamic> json)
      : id = 0,
        uid = json["UID"].toString(),
        panorama = json["Panorama"] == "true",
        width = int.parse(json["Width"].toString()),
        height = int.parse(json["Height"].toString()),
        imageHash = json["Hash"].toString(),
        imageQuality = null,
        lat = double.parse(json["Lat"].toString()),
        long = double.parse(json["Lng"].toString()),
        timestamp =
            DateTime.parse(json["TakenAt"].toString()).millisecondsSinceEpoch;

  @override
  String toString() {
    return "Photo: $uid";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is PhotoDataEntry &&
        other.uid == uid &&
        other.panorama == panorama &&
        other.width == width &&
        other.height == height &&
        other.imageHash == imageHash &&
        other.imageQuality == imageQuality &&
        other.lat == lat &&
        other.long == long &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode => Object.hash(
        uid,
        panorama,
        width,
        height,
        imageHash,
        imageQuality,
        lat,
        long,
        timestamp,
      );
}
