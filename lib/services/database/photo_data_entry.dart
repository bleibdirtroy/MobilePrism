import 'dart:ffi';

class PhotoDataEntry {
  final String uid;
  final bool? panorama;
  final int? width;
  final int? height;
  final String? imageHash;
  final String? imageQuality;
  final double? lat;
  final double? long;
  final Int64? timestamp;

  const PhotoDataEntry({
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
}
