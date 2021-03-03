part of 'user_timeline_bloc.dart';

abstract class UserTimelineEvent extends Equatable {
  const UserTimelineEvent();

  Stream<UserTimelineState> applyAsync({
    UserTimelineState currentState,
    UserTimelineBloc bloc,
  });
}
