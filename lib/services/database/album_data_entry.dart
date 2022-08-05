class AlbumDataEntry {
  final String albumUid;
  final List<String>? photoUids;
  final String title;
  final String thumbUid;

  const AlbumDataEntry({
    required this.albumUid,
    this.photoUids,
    required this.title,
    required this.thumbUid,
  });

  AlbumDataEntry.fromJson(Map<String, dynamic> json)
      : albumUid = json["UID"].toString(),
        photoUids = List<String>.empty(growable: true),
        title = json["Title"].toString(),
        thumbUid = json["Thumb"].toString();

  @override
  String toString() {
    return "Album: UID $albumUid | photoUids $photoUids | title $title | thumbUid $thumbUid";
  }
}
