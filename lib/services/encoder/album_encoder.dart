import 'dart:convert';

import 'package:mobileprism/services/encoder/encoder_exceptions.dart';

class AlbumEncoder {
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
