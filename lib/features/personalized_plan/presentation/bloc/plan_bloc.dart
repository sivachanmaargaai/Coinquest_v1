import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/plan_step_entity.dart';
import 'plan_event.dart';
import 'plan_state.dart';

/// Loads (and can regenerate) the AI-generated 4-week spending plan.
/// TODO: replace mock data with GetPersonalizedPlanUseCase.
class PlanBloc extends Bloc<PlanEvent, PlanState> {
  PlanBloc() : super(const PlanState()) {
    on<PlanStarted>(_onStarted);
    on<PlanRegenerated>(_onRegenerated);
  }

  Future<void> _onStarted(PlanStarted event, Emitter<PlanState> emit) async {
    emit(state.copyWith(status: PlanStatus.loading));
    await Future.delayed(const Duration(milliseconds: 500));
    emit(
      state.copyWith(
        status: PlanStatus.loaded,
        planTitle: 'Your 4-Week Smart Spending Plan',
        steps: const [
          PlanStepEntity(
            stepNumber: 1,
            title: 'Week 1: Track Entertainment Spending',
            description:
                'Log every entertainment expense so we know your baseline.',
            status: PlanStepStatus.active,
          ),
          PlanStepEntity(
            stepNumber: 2,
            title: 'Week 2: Set a Spending Limit',
            description:
                'Set a category limit for entertainment based on Week 1 data.',
            status: PlanStepStatus.upcoming,
          ),
          PlanStepEntity(
            stepNumber: 3,
            title: 'Week 3: Complete a Saving Challenge',
            description:
                'Redirect what you save into your active savings goal.',
            status: PlanStepStatus.upcoming,
          ),
          PlanStepEntity(
            stepNumber: 4,
            title: 'Week 4: Review Progress',
            description:
                'Check how much closer you are to your goal and adjust.',
            status: PlanStepStatus.upcoming,
          ),
        ],
      ),
    );
  }

  Future<void> _onRegenerated(
    PlanRegenerated event,
    Emitter<PlanState> emit,
  ) async {
    emit(state.copyWith(status: PlanStatus.loading));
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: call real UseCase; for now just reload the same mock plan
    add(const PlanStarted());
  }
}
