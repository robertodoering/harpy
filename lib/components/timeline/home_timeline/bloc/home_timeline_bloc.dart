import 'package:harpy/components/timeline/common/bloc/timeline_bloc.dart';
import 'package:harpy/components/timeline/home_timeline/bloc/home_timeline_event.dart';

class HomeTimelineBloc extends TimelineBloc {
  HomeTimelineBloc() {
    add(const UpdateHomeTimelineEvent());
  }
}
