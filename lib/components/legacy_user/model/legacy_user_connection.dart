enum LegacyUserConnection {
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
LegacyUserConnection parseUserConnection(String connectionString) {
  switch (connectionString) {
    case 'following':
      return LegacyUserConnection.following;
    case 'following_requested':
      return LegacyUserConnection.followingRequested;
    case 'followed_by':
      return LegacyUserConnection.followedBy;
    case 'blocking':
      return LegacyUserConnection.blocking;
    case 'muting':
      return LegacyUserConnection.muting;
    default:
      return LegacyUserConnection.none;
  }
}
