import 'dart:convert';
import 'dart:developer';

import 'package:mobileprism/services/database/photo_data_entry.dart';
import 'package:mobileprism/services/encoder/encoder_exceptions.dart';

class PhotoEncoder {
  void stringToPhotoData(String jsonResponse, {String? albumId}) {
    final list = jsonDecode(jsonResponse);
    if (list is List<dynamic>) {
      for (final element in list) {
        if (element is Map<String, dynamic>) {
          final PhotoDataEntry albumDataEntry =
              PhotoDataEntry.fromJson(element);
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
