class PhotoPrismServer {
  static final PhotoPrismServer _photoPrismServer =
      PhotoPrismServer._internal();
  String username = "";
  String hostname = "";
  String sessionToken = "";
  String previewToken = "";

  factory PhotoPrismServer() {
    return _photoPrismServer;
  }

  PhotoPrismServer._internal();
}
