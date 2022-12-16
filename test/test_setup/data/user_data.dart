import 'package:harpy/api/api.dart';

final userDataHarpy = UserData(
  id: '12345',
  name: 'harpy',
  handle: 'harpy_app',
  description: 'a Twitter app built with Flutter · '
      'source available on GitHub · '
      'developed with ❤️ by @rbydev',
  descriptionEntities: const EntitiesData(
    userMentions: [UserMentionData(handle: 'rbydev')],
  ),
  url: const UrlData(
    displayUrl:
        'play.google.com/store/apps/details?id=com.robertodoering.harpy.free',
    expandedUrl:
        'https://play.google.com/store/apps/details?id=com.robertodoering.harpy.free',
    url: 'https://t.co/HPGeHdalEW',
  ),
  profileImage: UserProfileImage(
    mini: Uri.file('harpy_avatar.png'),
    normal: Uri.file('harpy_avatar.png'),
    bigger: Uri.file('harpy_avatar.png'),
    original: Uri.file('harpy_avatar.png'),
  ),
  followersCount: 6159,
  followingCount: 20,
  createdAt: DateTime.fromMillisecondsSinceEpoch(1543491078000),
);
