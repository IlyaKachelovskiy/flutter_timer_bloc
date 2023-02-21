abstract class TimerEvent {
  const TimerEvent();
}

/// сообщает TimerBloc, что таймер должен быть запущен.
class TimerStarted extends TimerEvent {
  const TimerStarted({required this.duration});

  final int duration;
}

/// сообщает TimerBloc, что таймер должен быть приостановлен.
class TimerPaused extends TimerEvent {
  const TimerPaused();
}

/// сообщает TimerBloc, что таймер должен быть возобновлен.
class TimerResumed extends TimerEvent {
  const TimerResumed();
}

/// сообщает TimerBloc, что таймер должен быть сброшен в исходное состояние.
class TimerReset extends TimerEvent {
  const TimerReset();
}

/// информирует TimerBloc о том, что произошел тик и что ему необходимо соответствующим образом обновить свое состояние.
class TimerTicked extends TimerEvent {
  const TimerTicked({required this.duration});

  final int duration;
}
