import 'package:flutter_test/flutter_test.dart';
import 'package:mobileprism/services/database_service.dart';

void main() {
  testWidgets('database service ...', (tester) async {
    print("OpeningDb");
    print((await isOpen()));
  });
}
