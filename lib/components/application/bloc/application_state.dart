abstract class ApplicationState {
  const ApplicationState();
}

/// The default state for the [ApplicationBloc] when we have not finished
/// initializing the app.
class AwaitingInitializationState extends ApplicationState {
  const AwaitingInitializationState();
}

/// Yielded as soon as the initialization finishes.
class InitializedState extends ApplicationState {
  const InitializedState() : super();
}
