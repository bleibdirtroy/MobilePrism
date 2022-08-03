class AlbumDataEntry {
  final String albumUid;
  final List<String> photoUids;
  final String title;
  final String thumbUid;

  const AlbumDataEntry({
    required this.albumUid,
    required this.photoUids,
    required this.title,
    required this.thumbUid,
  });
}