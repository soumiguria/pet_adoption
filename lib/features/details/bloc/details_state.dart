import 'package:equatable/equatable.dart';
import '../../../core/models/pet.dart';

abstract class DetailsState extends Equatable {
  const DetailsState();

  @override
  List<Object?> get props => [];
}

class DetailsInitial extends DetailsState {}

class DetailsLoaded extends DetailsState {
  final Pet pet;
  final bool isAdopted;
  final bool isFavorite;

  const DetailsLoaded({
    required this.pet,
    required this.isAdopted,
    required this.isFavorite,
  });

  @override
  List<Object?> get props => [pet, isAdopted, isFavorite];
}

class DetailsAdopted extends DetailsState {
  final Pet pet;
  const DetailsAdopted(this.pet);

  @override
  List<Object?> get props => [pet];
}
