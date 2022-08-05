import 'package:mobileprism/services/database/database_service.dart';

class AlbumDataEntry {
  late final String uid;
  late final List<String>? photoUids;
  late final String title;
  late final String thumbUid;

  AlbumDataEntry({
    required this.uid,
    this.photoUids,
    required this.title,
    required this.thumbUid,
  });

  AlbumDataEntry.fromMap(Map<String, Object?> data) {
    if (data["uid"] != null &&
        data["title"] != null &&
        data["thumb_uid"] != null) {
      uid = data["uid"]! as String;
      title = data["title"]! as String;
      thumbUid = data["thumb_uid"]! as String;
      if (data["photo_uids"] is List<String>) {
        photoUids = data["photo_uids"]! as List<String>;
      } else {
        photoUids = null;
      }
    } else {
      throw FieldsMissingException();
    }
  }

  Map<String, dynamic> toMap(){
    return {
      "uid": uid,
      "photo_uids": photoUids,
      "title": title,
      "thumb_uid": thumbUid
    };
  }
}
