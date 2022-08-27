import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobileprism/models/photo_data_entry.dart';

import '../resources/db_test_data.dart';
import '../resources/json_responses.dart';

void main() {
  test('Generate PhotoDataEntry from REST response', () async {
    final res = (jsonDecode(twoPhotosJson) as List<dynamic>)
        .map((e) => PhotoDataEntry.fromJson(e as Map<String, dynamic>))
        .toList();
    expect(res.length, 2);
  });

  test('Generate PhotoDataEntry from Db response', () async {
    final res = rawDbPhotoResponse.map((e) => PhotoDataEntry.fromDbEntry(e));
    expect(res.length, 2);
  });

  test('Generate Db entry from PhotoDataEntry', () async {
    final testData = [testPhoto1, testPhoto2];
    final res = testData.map((e) => e.toDbEntry()).toList();
    final expectedKey = [
      "uid",
      "panorama",
      "width",
      "height",
      "image_hash",
      "image_quality",
      "lat",
      "long",
      "timestamp"
    ];
    expect(
      const ListEquality().equals(res[0].keys.toList(), expectedKey),
      true,
    );
    expect(
      const ListEquality().equals(res[1].keys.toList(), expectedKey),
      true,
    );
    expect(res.length, 2);
  });
}
