// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pet_adoption_app/main.dart';
import 'package:pet_adoption_app/app.dart';

void main() {
  testWidgets('App shows HomePage with pet list and navigation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PetAdoptionApp());
    // Check for the app bar title
    expect(find.text('Pet Adoption'), findsOneWidget);
    // Check for the search bar
    expect(find.byType(TextField), findsOneWidget);
    // Check for the history and favorite icons
    expect(find.byIcon(Icons.history), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });
}
