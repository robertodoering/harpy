import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:logging/logging.dart';

part 'user_search_event.dart';

class UserSearchBloc extends PaginatedBloc {
  UserSearchBloc({
    this.silentErrors = false,
    this.lock = const Duration(seconds: 1),
  }) {
    cursor = 1;
  }

  final bool silentErrors;
  final Duration lock;

  static UserSearchBloc of(BuildContext context) =>
      context.watch<UserSearchBloc>();

  /// The result of the last user search request.
  List<UserData> users = [];

  String? lastQuery;

  @override
  bool get hasData => users.isNotEmpty;

  @override
  Duration get lockDuration => lock;
}
