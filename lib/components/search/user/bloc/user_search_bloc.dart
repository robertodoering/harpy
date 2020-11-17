import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/common/paginated_bloc/paginated_bloc.dart';
import 'package:harpy/core/api/twitter/user_data.dart';
import 'package:harpy/core/service_locator.dart';

class UserSearchBloc extends PaginatedBloc {
  final UserService userService = app<TwitterApi>().userService;

  static UserSearchBloc of(BuildContext context) =>
      context.watch<UserSearchBloc>();

  /// The result of the last user search request.
  List<UserData> users = <UserData>[];

  String lastQuery;

  @override
  bool get hasData => users.isNotEmpty;

  @override
  Duration get lockDuration => Duration.zero;
}
