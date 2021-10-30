import 'dart:async';

import 'package:dart_twitter_api/twitter_api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class ListMembersCubit extends PaginatedUsersCubit {
  ListMembersCubit({
    required this.listId,
  }) : super(const PaginatedState.loading()) {
    loadInitial();
  }

  final String listId;

  @override
  Future<PaginatedUsers> request([int? cursor]) {
    return app<TwitterApi>().listsService.members(
          listId: listId,
          cursor: cursor?.toString(),
          count: 200,
        );
  }
}
