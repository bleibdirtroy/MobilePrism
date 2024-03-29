import 'dart:collection';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mobileprism/constants/application.dart';
import 'package:mobileprism/models/album_data_entry.dart';
import 'package:mobileprism/models/photo_data_entry.dart';
import 'package:mobileprism/models/photo_prism_server.dart';
import 'package:mobileprism/models/timeline_data_entry.dart';
import 'package:mobileprism/services/auth/auth_service.dart';

import 'package:mobileprism/services/database/database_service.dart';

import 'package:mobileprism/services/encoder/album_encoder.dart';
import 'package:mobileprism/services/encoder/photo_encoder.dart';
import 'package:mobileprism/services/rest_api/album_type.dart';
import 'package:mobileprism/services/rest_api/photo_format.dart';
import 'package:mobileprism/services/rest_api/rest_api_service.dart';

const allImages = 9999999;

class DataController {
  final albumEncoder = AlbumEncoder();
  final photoEncoder = PhotoEncoder();
  final RestApiService restApiService = RestApiService();
  final AuthService _authService = AuthService.secureStorage();

  DataController();

  Future<bool> createUser({
    required String hostname,
    String? username,
    String? password,
  }) async {
    if (hostname != "" && username != null && password != null) {
      // first login
      var sessionToken = "";
      var previewToken = "";
      try {
        final token = await restApiService.login(hostname, username, password);
        sessionToken = token.first;
        previewToken = token.last;
      } catch (e) {
        return false;
      }

      PhotoPrismServer().hostname = hostname;
      PhotoPrismServer().username = username;
      PhotoPrismServer().sessionToken = sessionToken;
      PhotoPrismServer().previewToken = previewToken;

      await _authService.storeUserData(
        hostname: hostname,
        username: username,
        password: password,
        sessionToken: sessionToken,
        previewToken: previewToken,
      );

      return true;
    } else if (hostname != "" && username == null && password == null) {
      // public Server
      if (!await _hasInternetConnection(hostname)) return false;

      PhotoPrismServer().hostname = hostname;
      PhotoPrismServer().username = "";
      PhotoPrismServer().sessionToken = "";
      PhotoPrismServer().previewToken = publicPhotoPrismPreviewToken;

      await _authService.storeUserData(
        hostname: hostname,
        username: "",
        password: "",
        sessionToken: "",
        previewToken: publicPhotoPrismPreviewToken,
      );
      return true;
    } else {
      return false;
    }
  }

  Future<List<AlbumDataEntry>> updateAlbums() async {
    if (await _hasInternetConnection()) {
      final albumsString = await restApiService.getAlbums(
        albumType: AlbumType.album,
        count: allImages,
      );
      final albums = (jsonDecode(albumsString) as List<dynamic>)
          .map((e) => AlbumDataEntry.fromJson(e as Map<String, dynamic>))
          .toList();
      DatabaseService().insertAlbums(albums);
    }

    return DatabaseService().getAlbums();
  }

  List<AlbumDataEntry> getAlbums() {
    return DatabaseService().getAlbums();
  }

  Future<List<PhotoDataEntry>> updatePhotosOfAlbum(
    String albumUid,
  ) async {
    if (await _hasInternetConnection()) {
      final photosString = await restApiService.getPhotos(
        count: allImages,
        albumUid: albumUid,
        merged: true,
      );
      final photos = photoEncoder.stringToPhotoData(photosString);
      DatabaseService().insertPhotos(photos);
      DatabaseService()
          .addPhotoUidsToAlbum(albumUid, photos.map((e) => e.uid).toList());
    }
    return DatabaseService().getAlbumPhotos(albumUid);
  }

  List<PhotoDataEntry> getPhotosOfAlbum(String albumUid) {
    return DatabaseService().getAlbumPhotos(albumUid);
  }

  Future<Map<int, SplayTreeSet<int>>> updateOccupiedDates() async {
    final Map<int, SplayTreeSet<int>> yearsAndMonths = {};

    if (await _hasInternetConnection()) {
      final albumsString = await restApiService.getAlbums(
        albumType: AlbumType.month,
        count: allImages,
      );
      final albums = albumEncoder.stringToAlbumsMap(albumsString);
      for (var i = 0; i < albums.length; i++) {
        final year = int.parse(albums[i]["Year"].toString());
        final month = int.parse(albums[i]["Month"].toString());
        final uid = albums[i]["UID"].toString();
        TimelineDataEntry(month: month, year: year, uid: uid);

        yearsAndMonths.containsKey(year)
            ? yearsAndMonths[year]!.add(month)
            : yearsAndMonths.addAll({
                year: SplayTreeSet<int>.from(
                  {month},
                  (a, b) => b.compareTo(a),
                )
              });
      }
      DatabaseService().insertTimelineAlbums(
        albums
            .map(
              (e) => TimelineDataEntry(
                month: int.parse(e["Month"].toString()),
                year: int.parse(e["Year"].toString()),
                uid: e["UID"].toString(),
              ),
            )
            .toList(),
      );
    }
    return DatabaseService().getTimlineAlbums();
  }

  Map<int, SplayTreeSet<int>> getOccupiedDates() {
    return DatabaseService().getTimlineAlbums();
  }

  Future<List<PhotoDataEntry>> updatePhotosOfMonthAndYear(DateTime time) async {
    if (await _hasInternetConnection()) {
      final photosString = await restApiService.getPhotos(
        count: allImages,
        month: time.month,
        year: time.year,
        merged: true,
      );
      final photos = (jsonDecode(photosString) as List<dynamic>)
          .map((e) => PhotoDataEntry.fromJson(e as Map<String, dynamic>))
          .toList();
      DatabaseService().insertPhotos(photos);
    }
    return DatabaseService().getPhotosByDateRange(
      time.millisecondsSinceEpoch,
      DateTime(time.year, time.month + 1).millisecondsSinceEpoch,
    );
  }

  List<PhotoDataEntry> getPhotosOfMonthAndYear(DateTime time) {
    return DatabaseService().getPhotosByDateRange(
      time.millisecondsSinceEpoch,
      DateTime(time.year, time.month + 1).millisecondsSinceEpoch,
    );
  }

  Future<bool> _hasInternetConnection([String? hostname]) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final pingResult = await restApiService.hasConnection(hostname);
    return (ConnectivityResult.none != connectivityResult) && pingResult;
  }

  Future<void> deleteAppStorage() async {
    DatabaseService().deleteDbContent();
    await _authService.deleteUserData();
  }

  String getPhotoUrl(String hash) {
    return "${PhotoPrismServer().hostname}${photoprismApiPath}t/$hash/${PhotoPrismServer().previewToken}/${PhotoFormat.fit_7680.toShortString()}";
  }

  String getPreviewPhotoUrl(String hash) {
    return "${PhotoPrismServer().hostname}${photoprismApiPath}t/$hash/${PhotoPrismServer().previewToken}/${PhotoFormat.tile_100.toShortString()}";
  }
}
