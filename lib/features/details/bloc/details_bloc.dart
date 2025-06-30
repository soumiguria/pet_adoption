import 'package:flutter_bloc/flutter_bloc.dart';
import 'details_event.dart';
import 'details_state.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/models/pet.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final LocalStorageService localStorageService;
  final Pet pet;

  DetailsBloc({required this.localStorageService, required this.pet})
    : super(DetailsInitial()) {
    on<AdoptPet>(_onAdoptPet);
    on<ToggleFavorite>(_onToggleFavorite);
    _init();
  }

  Future<void> _init() async {
    final adopted = await localStorageService.getAdoptedPets();
    final favorites = await localStorageService.getFavoritePets();
    final isAdopted = adopted.any((p) => p.id == pet.id);
    final isFavorite = favorites.any((p) => p.id == pet.id);
    emit(DetailsLoaded(pet: pet, isAdopted: isAdopted, isFavorite: isFavorite));
  }

  Future<void> _onAdoptPet(AdoptPet event, Emitter<DetailsState> emit) async {
    final adopted = await localStorageService.getAdoptedPets();
    if (!adopted.any((p) => p.id == event.pet.id)) {
      final updated = [...adopted, event.pet];
      await localStorageService.saveAdoptedPets(updated);
      emit(DetailsAdopted(event.pet));
    }
    _init();
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<DetailsState> emit,
  ) async {
    final favorites = await localStorageService.getFavoritePets();
    final isFav = favorites.any((p) => p.id == event.pet.id);
    List<Pet> updated;
    if (isFav) {
      updated = favorites.where((p) => p.id != event.pet.id).toList();
    } else {
      updated = [...favorites, event.pet];
    }
    await localStorageService.saveFavoritePets(updated);
    _init();
  }
}
