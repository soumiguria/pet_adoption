import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadPets extends HomeEvent {}

class SearchPets extends HomeEvent {
  final String query;
  const SearchPets(this.query);

  @override
  List<Object?> get props => [query];
}

class RefreshPets extends HomeEvent {}
