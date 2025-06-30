import 'package:equatable/equatable.dart';
import '../../../core/models/pet.dart';

abstract class DetailsEvent extends Equatable {
  const DetailsEvent();

  @override
  List<Object?> get props => [];
}

class AdoptPet extends DetailsEvent {
  final Pet pet;
  const AdoptPet(this.pet);

  @override
  List<Object?> get props => [pet];
}

class ToggleFavorite extends DetailsEvent {
  final Pet pet;
  const ToggleFavorite(this.pet);

  @override
  List<Object?> get props => [pet];
}
