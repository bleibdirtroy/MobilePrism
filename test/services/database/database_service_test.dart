import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobileprism/models/photo_data_entry.dart';
import 'package:mobileprism/services/database/database_service.dart';
import 'package:path/path.dart';

import '../../resources/db_test_data.dart';

void main() async {
  final testDbPath = join(Directory.current.path, "test", "objectbox");
  await Directory(testDbPath).delete(recursive: true);
  createStore(testDbPath: testDbPath);

  test('Test setting up db', () async {

  });
}
