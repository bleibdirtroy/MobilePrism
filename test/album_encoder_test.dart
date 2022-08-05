import 'package:flutter_test/flutter_test.dart';
import 'package:mobileprism/services/encoder/album_encoder.dart';

import 'constants/json_responses.dart';

void main() {
  group("Tests for album encoder", () {
    test("description", () {
      final AlbumEncoder _albumEncoder = AlbumEncoder();
      _albumEncoder.stringToAlbumData(oneAlbumJson);
      
    });
  });
}
