import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/local_storage_service.dart';
import 'home_event.dart';
import 'home_state.dart';

/// Loads the Home dashboard data + reads the persisted age group so the
/// UI can switch between Segment 1 (13–15, playful/gamified) and
/// Segment 2 (16–18, mature/data-forward) tone.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final LocalStorageService _localStorageService;

  HomeBloc({LocalStorageService? localStorageService})
    : _localStorageService = localStorageService ?? LocalStorageService(),
      super(const HomeState()) {
    on<HomeStarted>(_onStarted);
    on<HomeRefreshed>(_onRefreshed);
  }

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    await _loadData(emit);
  }

  Future<void> _onRefreshed(
    HomeRefreshed event,
    Emitter<HomeState> emit,
  ) async {
    await _loadData(emit);
  }

  Future<void> _loadData(Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));

    final savedGroup = await _localStorageService.getAgeGroup();
    final ageGroup = savedGroup == 'teen1618'
        ? HomeAgeGroup.teen1618
        : HomeAgeGroup.teen1315;

    await Future.delayed(const Duration(milliseconds: 400));

    // TODO: replace with real GetHomeUseCase call (data comes from backend)
    emit(
      state.copyWith(
        status: HomeStatus.loaded,
        ageGroup: ageGroup,
        userName: ageGroup == HomeAgeGroup.teen1618 ? 'Jordan' : 'Alex',
        balance: ageGroup == HomeAgeGroup.teen1618 ? 1250.75 : 125.50,
        level: 7,
        currentXp: 700,
        targetXp: 1000,
        savingsGoalTitle: ageGroup == HomeAgeGroup.teen1618
            ? 'First Car Fund'
            : 'New Laptop',
        savingsCurrent: ageGroup == HomeAgeGroup.teen1618 ? 3200 : 3350,
        savingsTarget: ageGroup == HomeAgeGroup.teen1618 ? 8000 : 8000,
        recentExpenses: const [
          RecentExpense(
            title: 'Lunch',
            category: 'Food',
            amount: -12.50,
            time: 'Today, 2:30 PM',
          ),
          RecentExpense(
            title: 'Bus Pass',
            category: 'Transport',
            amount: -8.00,
            time: 'Today, 9:00 AM',
          ),
          RecentExpense(
            title: 'Movie Ticket',
            category: 'Entertainment',
            amount: -15.00,
            time: 'Yesterday',
          ),
        ],
      ),
    );
  }
}
