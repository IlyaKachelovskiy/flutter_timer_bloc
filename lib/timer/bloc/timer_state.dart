import 'package:equatable/equatable.dart';

///TimerState - состояния которые могут быть у таймера
abstract class TimerState extends Equatable {
  const TimerState(this.duration);

  final int duration;

  @override
  List<Object> get props => [duration];
}

/// Нет отсчет, готов начать отсчет
class TimerInitial extends TimerState {
  const TimerInitial(super.duration);

  @override
  String toString() => 'TimerInitial { duration: $duration }';
}

/// Обратный отсчет идет
class TimerRunInProgress extends TimerState {
  const TimerRunInProgress(super.duration);

  @override
  String toString() => 'TimerRunInProgress { duration: $duration }';
}

/// Обратный отсчет на паузе
class TimerRunPause extends TimerState {
  const TimerRunPause(super.duration);

  @override
  String toString() => 'TimerRunPause { duration: $duration }';
}

/// Обратный отсчет закончен
class TimerRunComplete extends TimerState {
  const TimerRunComplete() : super(0);
}
