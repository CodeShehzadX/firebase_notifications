// Basic smoke test for the Instagram demo app.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_2_test/instagram_app/instagram_app.dart';

void main() {
  testWidgets('InstagramApp builds without crashing',
      (WidgetTester tester) async {
    await tester.pumpWidget(const InstagramApp());
    await tester.pump();

    // The home feed shows the app title in the app bar.
    expect(find.text('Instagram'), findsWidgets);
  });
}
