import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/local_storage_service.dart';
import 'age_selection_event.dart';
import 'age_selection_state.dart';

/// Tracks which age group (13–15 or 16–18) the user picked and persists
/// it to local storage so Home/Learn/Profile can load the correct
/// mascot + tone (Segment 1 vs Segment 2) on every future app launch.
class AgeSelectionBloc extends Bloc<AgeSelectionEvent, AgeSelectionState> {
  final LocalStorageService _localStorageService;

  AgeSelectionBloc({LocalStorageService? localStorageService})
    : _localStorageService = localStorageService ?? LocalStorageService(),
      super(const AgeSelectionState()) {
    on<AgeGroupSelected>(_onAgeGroupSelected);
    on<AgeSelectionConfirmed>(_onConfirmed);
  }

  void _onAgeGroupSelected(
    AgeGroupSelected event,
    Emitter<AgeSelectionState> emit,
  ) {
    emit(state.copyWith(selectedGroup: event.group));
  }

  Future<void> _onConfirmed(
    AgeSelectionConfirmed event,
    Emitter<AgeSelectionState> emit,
  ) async {
    if (state.selectedGroup == null) return;

    final String key = state.selectedGroup == AgeGroup.teen1315
        ? 'teen1315'
        : 'teen1618';

    await _localStorageService.saveAgeGroup(key);

    emit(state.copyWith(isConfirmed: true));
  }
}
