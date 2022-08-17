class CrossTableEntry {
  late final String albumUid;
  late final String photoUid;

  CrossTableEntry({
    required this.albumUid,
    required this.photoUid,
  });

  CrossTableEntry.fromDbEntry(Map<String, dynamic> data) {
    photoUid = data["photo_uid"] as String;
    albumUid = data["album_uid"] as String;
  }

  Map<String, dynamic> toDbEntry() => {
        "photo_uid": photoUid,
        "album_uid": albumUid,
      };
}
