import 'dart:convert';

import 'package:mobileprism/models/photo_data_entry.dart';
import 'package:mobileprism/services/encoder/encoder_exceptions.dart';

class PhotoEncoder {
  List<PhotoDataEntry> stringToPhotoData(String jsonResponse) {
    final photos = List<PhotoDataEntry>.empty(growable: true);
    final list = jsonDecode(jsonResponse);
    if (list is List<dynamic>) {
      for (final element in list) {
        if (element is Map<String, dynamic>) {
          final PhotoDataEntry photoDataEntry =
              PhotoDataEntry.fromJson(element);
          photos.add(photoDataEntry);
        } else {
          throw ResponseNotParsableException();
        }
      }
      return photos;
    } else {
      throw NoListResponseException();
    }
  }

  List<Map<String, dynamic>> stringToPhotoMap(String jsonResponse) {
    final albums = List<Map<String, dynamic>>.empty(growable: true);
    final list = jsonDecode(jsonResponse);

    if (list is List<dynamic>) {
      for (final element in list) {
        if (element is Map<String, dynamic>) {
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
