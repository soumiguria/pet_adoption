// // To run this test, add integration_test as a dev dependency in pubspec.yaml
// // dev_dependencies:
// //   integration_test:

// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:pet_adoption_app/main.dart' as app;
// import 'package:flutter/material.dart';

// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();

//   testWidgets('adopting a pet shows Adopted tag on home screen', (
//     WidgetTester tester,
//   ) async {
//     app.main();
//     await tester.pumpAndSettle();

//     // Tap the first pet card (Card widget)
//     final petCard = find.byType(Card).first;
//     await tester.tap(petCard);
//     await tester.pumpAndSettle();

//     // Tap the Adopt Me button
//     final adoptButton = find.text('Adopt Me');
//     await tester.tap(adoptButton);
//     await tester.pumpAndSettle();

//     // Confirm dialog
//     final okButton = find.text('OK');
//     if (okButton.evaluate().isNotEmpty) {
//       await tester.tap(okButton);
//       await tester.pumpAndSettle();
//     }

//     // Go back to home
//     await tester.pageBack();
//     await tester.pumpAndSettle();

//     // Check for Adopted tag
//     expect(find.text('Adopted'), findsWidgets);
//   });
// }
