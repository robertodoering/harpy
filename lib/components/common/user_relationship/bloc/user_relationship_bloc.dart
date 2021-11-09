import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/core/core.dart';

part 'user_relationship_bloc.freezed.dart';
part 'user_relationship_event.dart';

/// Handles the relationship between the authenticated user and other users.
///
/// The relationship connections can include:
/// * `none`
/// * `following`
/// * `following_requested`
/// * `followed_by`
/// * `blocking`
/// * `muting`
// TODO: support requesting connections for more than just one user at a time
//  https://github.com/robertodoering/harpy/issues/468
class UserRelationshipBloc
    extends Bloc<UserRelationshipEvent, UserRelationshipState>
    with HarpyLogger {
  UserRelationshipBloc({
    required String handle,
  })  : _handle = handle,
        super(const UserRelationshipState.initial()) {
    on<UserRelationshipEvent>(
      (event, emit) => event.handle(this, emit),
      transformer: sequential(),
    );

    add(const UserRelationshipEvent.load());
  }

  final String _handle;
}

@freezed
class UserRelationshipState with _$UserRelationshipState {
  const factory UserRelationshipState.initial() = _Initial;
  const factory UserRelationshipState.loading() = _Loading;

  const factory UserRelationshipState.data({
    /// The 'connections' of this relationship for the authenticated user.
    ///
    /// Can include: `following`, `following_requested`, `followed_by`, `none`,
    /// `blocking`, `muting`.
    required BuiltSet<String> connections,
  }) = _Data;

  const factory UserRelationshipState.error() = _Error;
}

extension UserRelationshipStateExtension on UserRelationshipState {
  bool get following => maybeWhen(
        data: (connections) => connections.contains('following'),
        orElse: () => false,
      );

  bool get followedBy => maybeWhen(
        data: (connections) => connections.contains('followed_by'),
        orElse: () => false,
      );

  bool get hasData => this is _Data;
}
