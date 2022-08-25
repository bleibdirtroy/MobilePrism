import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobileprism/models/timeline_data_entry.dart';

import '../resources/db_test_data.dart';
import '../resources/json_responses.dart';

void main() {
  test('Generate TimelineDataEntry data entry from REST response', () async {
    final res = (jsonDecode(timelineResponse1) as List<dynamic>)
        .map((e) => TimelineDataEntry.fromJson(e as Map<String, dynamic>))
        .toList();
    expect(res.length, 45);
  });

  test('Generate TimelineDataEntry from Db response', () async {
    final res =
        rawDbTimlineResponse.map((e) => TimelineDataEntry.fromDbEntry(e));
    expect(res.length, 2);
  });

  test('Generate Db entry from TimelineDataEntry', () async {
    final testData = [timelineData1, timelineData2];
    final res = testData.map((e) => e.toDbEntry()).toList();
    final expectedKey = ["uid", "year", "month"];
    expect(
        const ListEquality().equals(res[0].keys.toList(), expectedKey), true,);
    expect(
        const ListEquality().equals(res[1].keys.toList(), expectedKey), true,);
    expect(res.length, 2);
  });
}
