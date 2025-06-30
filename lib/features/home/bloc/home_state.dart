import 'package:equatable/equatable.dart';
import '../../../core/models/pet.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Pet> pets;
  final List<Pet> filteredPets;

  const HomeLoaded({required this.pets, required this.filteredPets});

  @override
  List<Object?> get props => [pets, filteredPets];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
