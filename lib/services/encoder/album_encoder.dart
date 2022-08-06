import 'dart:convert';
import 'dart:developer';

import 'package:mobileprism/services/database/album_data_entry.dart';
import 'package:mobileprism/services/encoder/encoder_exceptions.dart';

class AlbumEncoder {
  void stringToAlbumData(String jsonResponse) {
    final list = jsonDecode(jsonResponse);
    if (list is List<dynamic>) {
      for (final element in list) {
        if (element is Map<String, dynamic>) {
          final AlbumDataEntry albumDataEntry =
              AlbumDataEntry.fromJson(element);
          log(albumDataEntry.toString());
        } else {
          throw ResponseNotParsableException();
        }
      }
    } else {
      throw NoListResponseException();
    }
  }
}
