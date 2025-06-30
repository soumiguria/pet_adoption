import 'package:equatable/equatable.dart';
import '../../../core/models/pet.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Pet> favoritePets;
  const FavoritesLoaded(this.favoritePets);

  @override
  List<Object?> get props => [favoritePets];
}
