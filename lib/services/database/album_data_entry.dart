class AlbumDataEntry {
  late final String uid;
  late final String title;
  late final String thumbUid;

  AlbumDataEntry({
    required this.uid,
    required this.title,
    required this.thumbUid,
  });

  AlbumDataEntry.fromDbEntry(Map<String, dynamic> data) {
    uid = data["uid"] as String;
    title = data["title"] as String;
    thumbUid = data["thumb_uid"] as String;
  }

  Map<String, dynamic> toDbEntry() =>
      {"uid": uid, "title": title, "thumb_uid": thumbUid};
}
