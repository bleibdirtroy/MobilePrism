import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobileprism/models/album_data_entry.dart';

import '../resources/db_test_data.dart';
import '../resources/json_responses.dart';

void main() {
  test('Generate AlbumDataEntry data entry from REST response', () async {
    final res = (jsonDecode(timelineResponse1) as List<dynamic>)
        .map((e) => AlbumDataEntry.fromJson(e as Map<String, dynamic>))
        .toList();
    expect(res.length, 45);
  });

  test('Generate AlbumDataEntry from Db response', () async {
    final res = rawDbAlbumResponse.map((e) => AlbumDataEntry.fromDbEntry(e));
    expect(res.length, 2);
  });

  test('Generate Db entry from AlbumDataEntry', () async {
    final testData = [testAlbum1, testAlbum2];
    final res = testData.map((e) => e.toDbEntry()).toList();
    final expectedKey = ["uid", "title", "thumb_hash"];
    expect(
        const ListEquality().equals(res[0].keys.toList(), expectedKey), true,);
    expect(
        const ListEquality().equals(res[1].keys.toList(), expectedKey), true,);
    expect((res[0].values.first.toString()) == "1", true);
    expect(res[0].values.elementAt(1).toString() == "title", true);
    expect(res[0].values.elementAt(2).toString() == "1", true);
    expect(res[1].values.first.toString() == "2", true);
    expect(res[1].values.elementAt(1).toString() == "title", true);
    expect(res[1].values.elementAt(2).toString() == "2", true);
  });
}
