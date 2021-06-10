part of 'replies_bloc.dart';

abstract class RepliesState extends Equatable {
  const RepliesState();
}

extension RepliesStateExtension on RepliesState {
  bool get isLoading => this is LoadingReplies;

  bool get hasFailed => this is RepliesFailure;

  bool get hasResult => this is RepliesResult;

  bool get hasNoResult => this is RepliesNoResult;

  bool get hasParent => parent != null;

  TweetData? get parent {
    if (this is RepliesResult) {
      return (this as RepliesResult).parent;
    } else if (this is RepliesNoResult) {
      return (this as RepliesNoResult).parent;
    } else if (this is RepliesFailure) {
      return (this as RepliesFailure).parent;
    }
  }

  List<TweetData> get replies {
    if (this is RepliesResult) {
      return (this as RepliesResult).replies;
    } else {
      return [];
    }
  }
}

/// The state when the replies are loading
class LoadingReplies extends RepliesState {
  const LoadingReplies();

  @override
  List<Object?> get props => [];
}

/// The state when the replies have successfully been request.
class RepliesResult extends RepliesState {
  const RepliesResult({
    required this.replies,
    this.parent,
  });

  /// The list of replies for this tweet.
  final List<TweetData> replies;

  /// When the tweet is a reply itself, the [parent] will contain the parent
  /// reply chain.
  final TweetData? parent;

  @override
  List<Object?> get props => [
        replies,
        parent,
      ];
}

/// The state when requesting the replies was successfull but no replies exist.
class RepliesNoResult extends RepliesState {
  const RepliesNoResult({
    this.parent,
  });

  /// When the tweet is a reply itself, the [parent] will contain the parent
  /// reply chain.
  final TweetData? parent;

  @override
  List<Object?> get props => [
        parent,
      ];
}

/// The state when requesting the replies failed.
class RepliesFailure extends RepliesState {
  const RepliesFailure({
    this.parent,
  });

  /// When thetweet is a reply itself, the [parent] will contain the parent
  /// reply chain.
  final TweetData? parent;

  @override
  List<Object?> get props => [
        parent,
      ];
}
