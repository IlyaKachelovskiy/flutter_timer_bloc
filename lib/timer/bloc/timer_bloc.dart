import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer/timer/bloc/timer_event.dart';
import 'package:flutter_timer/timer/bloc/timer_state.dart';
import 'package:flutter_timer/timer/timer.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc({required Ticker ticker})
      : _ticker = ticker,
        super(const TimerInitial(_duration)) {
    on<TimerStarted>(_onStarted);
    on<TimerTicked>(_onTicked);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerReset>(_onReset);
  }

  final Ticker _ticker;

  /// начальное состояние
  static const int _duration = 60;

  StreamSubscription<int>? _tickerSubscription;

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  /// Если TimerBloc получает событие TimerStarted, он отправляет состояние
  /// TimerRunInProgress с текущей продолжительностью (60 сек).
  ///
  /// Если уже была открыта _tickerSubscription, то ее нужно закрыть, чтобы освободить память.
  ///
  /// Также нужно переопределить метод close для TimerBloc,для отмены
  /// _tickerSubscription, когда TimerBloc закрыт.
  ///
  /// Слушаем поток _ticker.tick и на каждом тике добавляем событие TimerTicked с оставшейся
  /// продолжительностью.
  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    emit(TimerRunInProgress(event.duration));
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: event.duration)
        .listen((duration) => add(TimerTicked(duration: duration)));
  }

  /// При получении события TimerTicked идет проверка.
  /// Если продолжительность тика больше 0, отправляет TimerRunInProgress с
  /// новой продолжительностью, иначе отправить состояние TimerRunComplete.
  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    emit(
      event.duration > 0
          ? TimerRunInProgress(event.duration)
          : const TimerRunComplete(),
    );
  }

  /// Если состояние TimerRunInProgress, останавливается подписка
  /// _tickerSubscription и высвобождается состояние TimerRunPause таймер
  /// останавливается на текущей секунде.
  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerRunInProgress) {
      _tickerSubscription?.pause();
      emit(TimerRunPause(state.duration));
    }
  }

  /// Если состояние TimerRunPause, возобновляется подписка
  /// _tickerSubscription и высвобождается состояние TimerRunInProgress таймера
  /// продолжает тикать.
  void _onResumed(TimerResumed resume, Emitter<TimerState> emit) {
    if (state is TimerRunPause) {
      _tickerSubscription?.resume();
      emit(TimerRunInProgress(state.duration));
    }
  }

  /// Если TimerBloc получает событие TimerReset, ему нужно отменить текущее
  /// _tickerSubscription, чтобы он не уведомлялся о каких-либо дополнительных
  /// тиках и выдвигал состояние TimerInitial с исходной продолжительностью.
  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    emit(const TimerInitial(_duration));
  }
}
