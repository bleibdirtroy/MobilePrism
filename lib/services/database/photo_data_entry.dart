import 'package:mobileprism/services/database/database_service.dart';
import 'package:mobileprism/services/rest_api/photo_format.dart';

class PhotoDataEntry {
  late final String uid;
  late final bool? panorama;
  late final int? width;
  late final int? height;
  late final String? imageHash;
  late final String? imageQuality;
  late final double? lat;
  late final double? long;
  late final int? timestamp;

  PhotoDataEntry({
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

  PhotoDataEntry.fromMap(Map<String, Object?> data) {
    if (data["uid"] != null) {
      uid = data["uid"]! as String;
      if (data["panorama"] is int) {
        panorama = data["panorama"]! as bool;
      } else {
        panorama = null;
      }

      if (data["width"] is int) {
        width = data["width"]! as int;
      } else {
        width = null;
      }
      width = data["width"] is int ? data["width"]! as int : null;

      if (data["height"] is int) {
        height = data["height"]! as int;
      } else {
        height = null;
      }

      if (data["image_hash"] is String) {
        imageHash = data["image_hash"]! as String;
      } else {
        imageHash = null;
      }

      if (data["image_quality"] is String) {
        imageQuality = data["image_quality"]! as String;
      } else {
        imageQuality = null;
      }

      if (data["lat"] is num) {
        lat = data["lat"]! as double;
      } else {
        lat = null;
      }

      if (data["long"] is num) {
        long = data["long"]! as double;
      } else {
        long = null;
      }

      if (data["timestamp"] is num) {
        timestamp = int.parse(data["timestamp"]!.toString());
      } else {
        timestamp = null;
      }
    } else {
      throw FieldsMissingException();
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "panorama": panorama,
      "width": width,
      "height": height,
      "imageHash": imageHash,
      "image_quality": imageQuality,
      "lat": lat,
      "long": long,
      "timestamp": timestamp
    };
  }

  PhotoDataEntry.fromJson(Map<String, dynamic> json)
      : uid = json["UID"].toString(),
        panorama = json["Panorama"] == "true",
        width = int.parse(json["Width"].toString()),
        height = int.parse(json["Height"].toString()),
        imageHash = json["Hash"].toString(),
        imageQuality = PhotoFormat.fit_7680.toShortString(),
        lat = double.parse(json["Lat"].toString()),
        long = double.parse(json["Lng"].toString()),
        timestamp =
            DateTime.parse(json["TakenAt"].toString()).millisecondsSinceEpoch;
}
