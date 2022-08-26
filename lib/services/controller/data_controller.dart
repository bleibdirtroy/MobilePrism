import 'dart:collection';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mobileprism/constants/application.dart';
import 'package:mobileprism/models/photo_prism_server.dart';
import 'package:mobileprism/services/database/album_data_entry.dart';
import 'package:mobileprism/services/database/database_service.dart';
import 'package:mobileprism/services/database/photo_data_entry.dart';
import 'package:mobileprism/services/database/timeline_data_entry.dart';
import 'package:mobileprism/services/encoder/album_encoder.dart';
import 'package:mobileprism/services/encoder/photo_encoder.dart';
import 'package:mobileprism/services/rest_api/album_type.dart';
import 'package:mobileprism/services/rest_api/photo_format.dart';
import 'package:mobileprism/services/rest_api/rest_api_service.dart';

const allImages = 9999999;

class DataController {
  final albumEncoder = AlbumEncoder();
  final photoEncoder = PhotoEncoder();
  RestApiService restApiService = RestApiService();

  DataController();

  Future<List<AlbumDataEntry>> getAlbums() async {
    if (await _hasInternetConnection()) {
      final albumsString = await restApiService.getAlbums(
        albumType: AlbumType.album,
        count: allImages,
      );
      final albums = (jsonDecode(albumsString) as List<dynamic>)
          .map((e) => AlbumDataEntry.fromJson(e as Map<String, dynamic>))
          .toList();
      await DatabaseService().insertAlbums(albums);
    }

    return DatabaseService().getAlbums();
  }

  Future<List<PhotoDataEntry>> getPhotosOfAlbum(
    String albumUid,
  ) async {
    final photosString = await restApiService.getPhotos(
      count: allImages,
      albumUid: albumUid,
    );
    return photoEncoder.stringToPhotoData(photosString);
  }

  Future<Map<int, SplayTreeSet<int>>> getOccupiedDates() async {
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
      await DatabaseService().insertTimelineAlbums(
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

  Future<List<PhotoDataEntry>> getPhotosOfMonthAndYear(DateTime time) async {
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
      await DatabaseService().insertPhotos(photos);
    }
    return DatabaseService().getPhotosByDateRange(
      time.millisecondsSinceEpoch,
      DateTime(time.year, time.month + 1, 0).millisecondsSinceEpoch,
    );
  }

  Future<bool> _hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return ConnectivityResult.none != connectivityResult;
  }

  String getPhotoUrl(String hash) {
    return "${PhotoPrismServer().hostname}${photoprismApiPath}t/$hash/${PhotoPrismServer().previewToken}/${PhotoFormat.fit_7680.toShortString()}";
  }

  String getPreviewPhotoUrl(String hash) {
    return "${PhotoPrismServer().hostname}${photoprismApiPath}t/$hash/${PhotoPrismServer().previewToken}/${PhotoFormat.tile_100.toShortString()}";
  }
}
