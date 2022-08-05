import 'dart:convert';

import 'package:mobileprism/services/database/album_data_entry.dart';
import 'package:mobileprism/services/encoder/encoder_exceptions.dart';

class AlbumEncoder {

  Future<void> stringToAlbumData(String jsonResponse) async {
    final list = jsonDecode(jsonResponse) as List<dynamic>;
    for (final element in list) {
      if (element is Map<String, dynamic>) {
        final AlbumDataEntry albumDataEntry = AlbumDataEntry.fromJson(element);
      } else {
        throw ResponseNotParsableException();
      }
    }
  }

  
}
