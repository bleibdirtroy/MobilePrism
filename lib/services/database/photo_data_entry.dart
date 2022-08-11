
// @JsonSerializable(fieldRename: FieldRename.snake)
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
    uid = data["uid"]! as String;
    panorama = data["panorama"] is int ? data["panorama"]! as bool : null;
    width = data["width"] is int ? data["width"]! as int : null;
    imageHash = data["image_hash"] is String ? data["image_hash"]! as String : null;
    imageQuality = data["image_quality"] is String ? data["image_quality"]! as String : null;
    lat = data["lat"] is num ? data["lat"]! as double : null;
    long = data["long"] is num ? data["long"]! as double : null;
    timestamp = data["timestamp"] is num ? data["timestamp"]! as int : null;
  }

  Map<String, dynamic> toMap() => {
      "uid": uid,
      "panorama": panorama != null ? (panorama! ? 1:0) : null,
      "width": width,
      "height": height,
      "image_hash": imageHash,
      "image_quality": imageQuality,
      "lat": lat,
      "long": long,
      "timestamp": timestamp
    };
}
