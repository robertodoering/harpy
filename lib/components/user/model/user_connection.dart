enum UserConnection {
  none,
  following,
  followingRequested,
  followedBy,
  blocking,
  muting,
}

/// The Twitter returned relationship connections can include:
/// * `none`
/// * `following`
/// * `following_requested`
/// * `followed_by`
/// * `blocking`
/// * `muting`
UserConnection parseUserConnection(String connectionString) {
  switch (connectionString) {
    case 'following':
      return UserConnection.following;
    case 'following_requested':
      return UserConnection.followingRequested;
    case 'followed_by':
      return UserConnection.followedBy;
    case 'blocking':
      return UserConnection.blocking;
    case 'muting':
      return UserConnection.muting;
    default:
      return UserConnection.none;
  }
}
