import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pet.dart';

class LocalStorageService {
  static const String adoptedKey = 'adopted_pets';
  static const String favoritesKey = 'favorite_pets';

  Future<void> saveAdoptedPets(List<Pet> pets) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = pets.map((pet) => pet.toJson()).toList();
    await prefs.setString(adoptedKey, json.encode(jsonList));
  }

  Future<List<Pet>> getAdoptedPets() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(adoptedKey);
    if (jsonString == null) return [];
    final List<dynamic> data = json.decode(jsonString);
    return data.map((json) => Pet.fromJson(json)).toList();
  }

  Future<void> saveFavoritePets(List<Pet> pets) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = pets.map((pet) => pet.toJson()).toList();
    await prefs.setString(favoritesKey, json.encode(jsonList));
  }

  Future<List<Pet>> getFavoritePets() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(favoritesKey);
    if (jsonString == null) return [];
    final List<dynamic> data = json.decode(jsonString);
    return data.map((json) => Pet.fromJson(json)).toList();
  }
}
