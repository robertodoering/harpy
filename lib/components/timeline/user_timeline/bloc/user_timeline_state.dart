part of 'user_timeline_bloc.dart';

abstract class UserTimelineState extends Equatable {
  const UserTimelineState();
}

class UserTimelineInitial extends UserTimelineState {
  const UserTimelineInitial();

  @override
  List<Object> get props => <Object>[];
}
