import 'package:flutter_bloc/flutter_bloc.dart';
import 'history_event.dart';
import 'history_state.dart';
import '../../../core/services/local_storage_service.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final LocalStorageService localStorageService;

  HistoryBloc({required this.localStorageService}) : super(HistoryInitial()) {
    on<LoadHistory>(_onLoadHistory);
  }

  Future<void> _onLoadHistory(
    LoadHistory event,
    Emitter<HistoryState> emit,
  ) async {
    final adopted = await localStorageService.getAdoptedPets();
    adopted.sort((a, b) => a.name.compareTo(b.name));
    emit(HistoryLoaded(adopted));
  }
}
