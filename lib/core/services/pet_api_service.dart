import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pet.dart';

class PetApiService {
  Future<List<Pet>> fetchPets() async {
    final response = await http.get(Uri.parse('http://localhost:3000/pets'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Pet.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load pets from API');
    }
  }
}
