class AlbumDataEntry {
  late final String uid;
  late final String title;
  late final String thumbUid;

  AlbumDataEntry({
    required this.uid,
    required this.title,
    required this.thumbUid,
  });

  AlbumDataEntry.fromMap(Map<String, Object?> data) {
    uid = data["uid"]! as String;
    title = data["title"]! as String;
    thumbUid = data["thumb_uid"]! as String;
  }

  Map<String, dynamic> toMap() =>
      {"uid": uid, "title": title, "thumb_uid": thumbUid};
}
