import 'dart:collection';

import 'package:mobileprism/services/database/album_data_entry.dart';
import 'package:mobileprism/services/database/photo_data_entry.dart';
import 'package:mobileprism/services/encoder/album_encoder.dart';
import 'package:mobileprism/services/encoder/photo_encoder.dart';
import 'package:mobileprism/services/rest_api/album_type.dart';
import 'package:mobileprism/services/rest_api/rest_api_service.dart';

class DataController {
  final albumEncoder = AlbumEncoder();
  final photoEncoder = PhotoEncoder();
  late final restApiService = RestApiService("https://demo-de.photoprism.app");

  DataController();

  Future<void> getAlbums() async {
    final albumsString = await restApiService.getAlbums(
      albumType: AlbumType.album,
      count: 9999999,
    );
    final albumsMap = albumEncoder.stringToAlbumsMap(albumsString);
    final albums = albumEncoder.stringToAlbumData(albumsString);

    for (var i = 0; i < albums.length; i++) {
      getPhotoOfHash(albumsMap[i]["hash"].toString());
      albums[i].thumbUid =
          (await getPhotoOfHash(albumsMap[i]["hash"].toString())).uid;
      albums[i].photoUids =
          (await getPhotosOfAlbum(albums[i])).map((e) => e.uid).toList();
    }
  }

  Future<PhotoDataEntry> getPhotoOfHash(String hash) async {
    final photoString = await restApiService.getPhoto(hash: hash);
    final photo = photoEncoder.stringToPhotoData(photoString)[0];
    return photo;
  }

  Future<List<PhotoDataEntry>> getPhotosOfAlbum(
    AlbumDataEntry albumDataEntry,
  ) async {
    final photosString = await restApiService.getPhotos(
      count: 9999999,
      albumUid: albumDataEntry.uid,
    );
    return photoEncoder.stringToPhotoData(photosString);
  }

  Future<List<PhotoDataEntry>> getPhotosByMonthAndYear(
    int month,
    int year,
  ) async {
    final photosString = await restApiService.getPhotos(
      count: 999999,
      month: month,
      year: year,
      merged: true,
    );
    return photoEncoder.stringToPhotoData(photosString);
  }

  Future<SplayTreeMap<int, SplayTreeSet<int>>> getAvailableYearsAndMonths() async {
    final SplayTreeMap<int, SplayTreeSet<int>> yearsAndMonths = SplayTreeMap();
    final albumsString = await restApiService.getAlbums(
      albumType: AlbumType.month,
      count: 9999999,
    );
    final albums = albumEncoder.stringToAlbumsMap(albumsString);
    for (var i = 0; i < albums.length; i++) {
      final year = int.parse(albums[i]["Year"].toString());
      final month = int.parse(albums[i]["Month"].toString());
      yearsAndMonths.containsKey(year)
          ? yearsAndMonths[year]!.add(month)
          : yearsAndMonths.addAll({
              year: SplayTreeSet<int>.from({month})
            });
    }
    return yearsAndMonths;
  }
}
