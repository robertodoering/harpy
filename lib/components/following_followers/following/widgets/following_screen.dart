import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/api/loading_data_error.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/common/paginated_bloc/paginated_state.dart';
import 'package:harpy/components/following_followers/following/bloc/following_bloc.dart';
import 'package:harpy/components/following_followers/following/bloc/following_event.dart';
import 'package:harpy/components/following_followers/following/widgets/content/following_list.dart';

/// Builds the screen with a list of the following users for the user with the
/// [userId].
class FollowingScreen extends StatelessWidget {
  const FollowingScreen({
    @required this.userId,
  });

  /// The [userId] of the user whom to search the following users for.
  final String userId;

  static const String route = 'following';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FollowingBloc>(
      create: (BuildContext context) => FollowingBloc(userId: userId),
      child: BlocBuilder<FollowingBloc, PaginatedState>(
        builder: (BuildContext context, PaginatedState state) {
          final FollowingBloc bloc = FollowingBloc.of(context);

          Widget child;

          if (bloc.loadingInitialData) {
            child = const Center(child: CircularProgressIndicator());
          } else if (bloc.showNoDataExists) {
            child = LoadingDataError(
              message: 'Error loading following users',
              onTap: () => bloc.add(const LoadFollowingUsers()),
            );
          } else {
            child = FollowingList(bloc);
          }

          return HarpyScaffold(
            title: 'Following',
            body: AnimatedSwitcher(
              duration: kShortAnimationDuration,
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              child: child,
            ),
          );
        },
      ),
    );
  }
}
