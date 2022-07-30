import 'package:flutter_test/flutter_test.dart';
import 'package:mobileprism/services/rest_api/album_type.dart';
import 'package:mobileprism/services/rest_api/order_type.dart';
import 'package:mobileprism/services/rest_api/rest_api_service.dart';

void main() {
  group("Tests for rest api calls", () {
    test("Test if the query parameters for album are set correctly", () {
      final RestApiService restApiService =
          RestApiService("https://demo-de.photoprism.app");
      final Uri uri = restApiService.buildAlbumURL(
        albumType: AlbumType.album,
        count: 2,
        offset: 3,
        orderType: OrderType.newest,
      );

      expect(uri.origin, contains("https://demo-de.photoprism.app"));
      expect(uri.path, contains("/api/v1/albums"));
      expect(uri.query, contains("count=2"));
      expect(uri.query, contains("type=album"));
      expect(uri.query, contains("offset=3"));
      expect(uri.query, contains("order=newest"));
    });

    test(
        "Test if the query parameters for album are set correctly for calendar",
        () {
      final RestApiService restApiService =
          RestApiService("https://demo-de.photoprism.app");
      final Uri uri = restApiService.buildAlbumURL(
        albumType: AlbumType.month,
        count: 2,
      );

      expect(uri.origin, contains("https://demo-de.photoprism.app"));
      expect(uri.path, contains("/api/v1/albums"));
      expect(uri.query, contains("count=2"));
      expect(uri.query, contains("type=month"));
    });

    test("Test if the query parameters for map are set correctly", () {
      final RestApiService restApiService =
          RestApiService("https://demo-de.photoprism.app");
      final Uri uri = restApiService.buildMapURL(
        public: true,
        count: 2,
        offset: 3,
        quality: 1,
      );

      expect(uri.origin, contains("https://demo-de.photoprism.app"));
      expect(uri.path, contains("/api/v1/geo"));
      expect(uri.query, contains("public=true"));
      expect(uri.query, contains("offset=3"));
      expect(uri.query, contains("quality=1"));
    });
    test("Test if the query parameters for photos are set correctly", () {
      const String albumUid = "thisIsMyAlbumUid";
      final RestApiService restApiService =
          RestApiService("https://demo-de.photoprism.app");
      final Uri uri = restApiService.buildPhotosUrl(
        count: 1,
        albumUid: albumUid,
        merged: true,
        orderType: OrderType.oldest,
        offset: 2,
      );

      expect(uri.origin, contains("https://demo-de.photoprism.app"));
      expect(uri.path, contains("/api/v1/photos"));
      expect(uri.query, contains("merged=true"));
      expect(uri.query, contains("offset=2"));
      expect(uri.query, contains("count=1"));
      expect(uri.query, contains("album=$albumUid"));
      expect(uri.query, contains("order=oldest"));
    });
    test(
        "Test if the query parameters for photos of month and year are set correctly",
        () {
      final RestApiService restApiService =
          RestApiService("https://demo-de.photoprism.app");
      final Uri uri = restApiService.buildPhotosUrl(
        count: 1,
        month: 12,
        year: 2017,
      );

      expect(uri.origin, contains("https://demo-de.photoprism.app"));
      expect(uri.path, contains("/api/v1/photos"));
      expect(uri.query, contains("count=1"));
      expect(uri.query, contains("filter=year:2017+month:12"));
    });

    test("Test if album response from server returns important values",
        () async {
      final RestApiService restApiService =
          RestApiService("https://demo-de.photoprism.app");
      final String response = await restApiService.getAlbums(
        albumType: AlbumType.album,
        count: 1,
      );
      expect(response, contains("UID"));
      expect(response, contains("Thumb"));
      expect(response, contains("Title"));
      expect(response, contains("PhotoCount"));
      expect(response, contains("CreatedAt"));
      expect(response, contains("UpdatedAt"));
    });
    test("Test if map response from server returns important values", () async {
      final RestApiService restApiService =
          RestApiService("https://demo-de.photoprism.app");
      final String response = await restApiService.getMap(
        public: true,
        count: 1,
      );
      expect(response, contains("coordinates"));
      expect(response, contains("type"));
      expect(response, contains("Hash"));
      expect(response, contains("Title"));
      expect(response, contains("TakenAt"));
    });
    test("Test if photos response from server returns important values",
        () async {
      final RestApiService restApiService =
          RestApiService("https://demo-de.photoprism.app");
      final String response = await restApiService.getPhotos(
        count: 1,
      );
      expect(response, contains("Hash"));
      expect(response, contains("Year"));
      expect(response, contains("Month"));
      expect(response, contains("Day"));
      expect(response, contains("Title"));
    });
  });
}
