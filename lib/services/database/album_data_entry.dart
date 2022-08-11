
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
    uid = data["uid"]! as String;
    title = data["title"]! as String;
    thumbUid = data["thumb_uid"]! as String;
    photoUids = data["photo_uids"] is String ? data["photo_uids"]! as List<String> : null;
  }

  Map<String, dynamic> toMap() => {
      "uid": uid,
      "photo_uids": photoUids,
      "title": title,
      "thumb_uid": thumbUid
    };
}
