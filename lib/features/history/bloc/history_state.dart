import 'package:equatable/equatable.dart';
import '../../../core/models/pet.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<Pet> adoptedPets;
  const HistoryLoaded(this.adoptedPets);

  @override
  List<Object?> get props => [adoptedPets];
}
