abstract class HomeViewState {}

class InitState extends HomeViewState {
  InitState();
}

class FailureState extends HomeViewState {
  String? error;

  FailureState({this.error});
}

class LoadingState extends HomeViewState {
  LoadingState();
}

class SuccessfulState extends HomeViewState {
  SuccessfulState();
}
