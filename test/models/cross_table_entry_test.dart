import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobileprism/models/cross_table_entry.dart';

import '../resources/db_test_data.dart';

void main() {
  test('Generate CrossTableDataEntry from Db response', () async {
    final res =
        rawDbCrosstableResponse.map((e) => CrossTableEntry.fromDbEntry(e));
    expect(res.length, 2);
  });

  test('Generate Db entry from CrossTableDataEntry', () async {
    final testData = [crossTableData1, crossTableData2];
    final res = testData.map((e) => e.toDbEntry()).toList();
    final expectedKey = ["photo_uid", "album_uid"];
    expect(
        const ListEquality().equals(res[0].keys.toList(), expectedKey), true,);
    expect(
        const ListEquality().equals(res[1].keys.toList(), expectedKey), true,);
    expect(res.length, 2);
  });
}
