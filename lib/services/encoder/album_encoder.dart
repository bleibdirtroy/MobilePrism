import 'dart:convert';
import 'dart:developer';

import 'package:mobileprism/services/database/album_data_entry.dart';
import 'package:mobileprism/services/encoder/encoder_exceptions.dart';

class AlbumEncoder {
  List<AlbumDataEntry> stringToAlbumData(String jsonResponse) {
    final albums = List<AlbumDataEntry>.empty(growable: true);
    final list = jsonDecode(jsonResponse);

    if (list is List<dynamic>) {
      for (final element in list) {
        if (element is Map<String, dynamic>) {
          final AlbumDataEntry albumDataEntry =
              AlbumDataEntry.fromJson(element);
          log(albumDataEntry.toString());
          albums.add(albumDataEntry);
        } else {
          throw ResponseNotParsableException();
        }
      }
      return albums;
    } else {
      throw NoListResponseException();
    }
  }

  List<Map<String, dynamic>> stringToAlbumsMap(String jsonResponse) {
    final albums = List<Map<String, dynamic>>.empty(growable: true);
    final list = jsonDecode(jsonResponse);

    if (list is List<dynamic>) {
      for (final element in list) {
        if (element is Map<String, dynamic>) {
          albums.add(element);
        } else {
          throw ResponseNotParsableException();
        }
      }
      return albums;
    } else {
      throw NoListResponseException();
    }
  }
}
