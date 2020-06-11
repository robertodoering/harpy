abstract class ApplicationState {
  const ApplicationState();
}

class AwaitingInitializationState extends ApplicationState {
  const AwaitingInitializationState();
}

class InitializedState extends ApplicationState {
  const InitializedState() : super();
}
