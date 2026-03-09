import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:micro_life_dashboard/main.dart';

void main() {
  testWidgets('App loads with Today screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Today'), findsOneWidget);
  });
}
