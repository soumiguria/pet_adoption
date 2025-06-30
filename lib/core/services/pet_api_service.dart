import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/pet.dart';

class PetApiService {
  Future<List<Pet>> fetchPets() async {
    final String response = await rootBundle.loadString(
      'assets/data/pets.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Pet.fromJson(json)).toList();
  }
}
