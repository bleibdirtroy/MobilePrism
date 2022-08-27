class AlbumDataEntry {
  late final String uid;
  late final String title;
  late final String thumbHash;

  AlbumDataEntry({
    required this.uid,
    required this.title,
    required this.thumbHash,
  });

  AlbumDataEntry.fromDbEntry(Map<String, dynamic> data) {
    uid = data["uid"] as String;
    title = data["title"] as String;
    thumbHash = data["thumb_hash"].toString();
  }

  AlbumDataEntry.fromJson(Map<String, dynamic> json)
      : uid = json["UID"] as String,
        title = json["Title"] as String,
        thumbHash = json["Thumb"].toString();

  Map<String, dynamic> toDbEntry() =>
      {"uid": uid, "title": title, "thumb_hash": thumbHash};
}
