class CrossTableEntry {
  late final String albumUid;
  late final String photoUid;

  CrossTableEntry({
    required this.albumUid,
    required this.photoUid,
  });

  CrossTableEntry.fromMap(Map<String, dynamic> data) {
    photoUid = data["photo_uid"]! as String;
    albumUid = data["album_uid"]! as String;
  }

  Map<String, dynamic> toMap() => {
        "photo_uid": photoUid,
        "album_uid": albumUid,
      };
}
