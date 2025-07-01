import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_adoption_app/core/models/pet.dart';
import 'package:pet_adoption_app/core/notifiers/adopted_pets_notifier.dart';
import 'package:pet_adoption_app/features/home/home_page.dart';

void main() {
  testWidgets('shows Adopted tag when pet is adopted', (
    WidgetTester tester,
  ) async {
    // Arrange: Add a pet to the adopted notifier
    const adoptedPetId = 'pet1';
    adoptedPetsNotifier.value = {adoptedPetId};

    // Create a fake pet
    final pet = Pet(
      id: adoptedPetId,
      name: 'Mochi',
      type: 'Cat',
      age: 2,
      price: 99.0,
      imageUrl:
          'https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg',
    );

    // Act: Build the HomeView with the adopted pet
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: HomeView())));
    await tester.pumpAndSettle();

    // Assert: The Adopted tag should be found
    expect(find.text('Adopted'), findsWidgets);
  });
}
