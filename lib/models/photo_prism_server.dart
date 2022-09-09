class PhotoPrismServer {
  static final PhotoPrismServer _photoPrismServer =
      PhotoPrismServer._internal();
  String username = "";
  String hostname = "";
  String sessionToken = "";
  String previewToken = "";
  bool useDatabaseOnly = false;

  factory PhotoPrismServer() {
    return _photoPrismServer;
  }

  PhotoPrismServer._internal();
}
