abstract class ApplicationState {}

/// The default state for the [ApplicationBloc] when we have not finished
/// initializing the app.
class AwaitingInitializationState extends ApplicationState {}

/// Yielded as soon as the initialization finishes.
class InitializedState extends ApplicationState {}
