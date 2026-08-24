import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Fired when Home screen first loads.
class HomeStarted extends HomeEvent {
  const HomeStarted();
}

/// Pull-to-refresh.
class HomeRefreshed extends HomeEvent {
  const HomeRefreshed();
}
