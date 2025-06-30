import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../../../core/services/pet_api_service.dart';
import '../../../core/models/pet.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PetApiService petApiService;

  HomeBloc({required this.petApiService}) : super(HomeInitial()) {
    on<LoadPets>(_onLoadPets);
    on<SearchPets>(_onSearchPets);
    on<RefreshPets>(_onRefreshPets);
  }

  Future<void> _onLoadPets(LoadPets event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final pets = await petApiService.fetchPets();
      emit(HomeLoaded(pets: pets, filteredPets: pets));
    } catch (e) {
      emit(HomeError('Failed to load pets'));
    }
  }

  void _onSearchPets(SearchPets event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final loadedState = state as HomeLoaded;
      final filtered =
          loadedState.pets
              .where(
                (pet) =>
                    pet.name.toLowerCase().contains(event.query.toLowerCase()),
              )
              .toList();
      emit(HomeLoaded(pets: loadedState.pets, filteredPets: filtered));
    }
  }

  Future<void> _onRefreshPets(
    RefreshPets event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final pets = await petApiService.fetchPets();
      emit(HomeLoaded(pets: pets, filteredPets: pets));
    } catch (e) {
      emit(HomeError('Failed to refresh pets'));
    }
  }
}
