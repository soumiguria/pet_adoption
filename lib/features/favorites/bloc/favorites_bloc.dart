import 'package:flutter_bloc/flutter_bloc.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';
import '../../../core/services/local_storage_service.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final LocalStorageService localStorageService;

  FavoritesBloc({required this.localStorageService})
    : super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    final favorites = await localStorageService.getFavoritePets();
    emit(FavoritesLoaded(favorites));
  }
}
