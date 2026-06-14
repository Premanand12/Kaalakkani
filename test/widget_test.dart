import 'package:flutter_test/flutter_test.dart';
import 'package:kaalakkani/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    expect(KaalakkaniApp, isNotNull);
  });
}
