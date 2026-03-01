sealed class ResultState {}

class LoadingState extends ResultState {}

class HasDataState<T> extends ResultState {
  final T data;
  HasDataState(this.data);
}

class ErrorState extends ResultState {
  final String message;
  ErrorState(this.message);
}

class NoDataState extends ResultState {
  final String message;
  NoDataState(this.message);
}

class IdleState extends ResultState {
  IdleState();
}

class SuccessState extends ResultState {
  final String message;
  SuccessState(this.message);
}
