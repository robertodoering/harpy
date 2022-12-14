import 'package:alchemist/alchemist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/pages/user/widgets/user_page_header.dart';

import '../../../test_setup/data/user_data.dart';
import '../../../test_setup/setup.dart';
import 'user_page_test.dart';

void main() {
  setUpAll(loadAppFonts);

  group('$UserPageHeader', () {
    goldenTest(
      'following',
      fileName: 'user_page_header_following',
      constraints: phoneConstrains,
      pumpWidget: pumpAppBase,
      pumpBeforeTest: primeAssetsAndSettle,
      builder: () => buildSingleSliver(
        UserPageHeader(
          data: userPageData.copyWith.relationship!(following: true),
          notifier: MockUserPageNotifier(),
          isAuthenticatedUser: false,
        ),
      ),
    );

    goldenTest(
      'follow requested',
      fileName: 'user_page_header_follow_requested',
      constraints: phoneConstrains,
      pumpWidget: pumpAppBase,
      pumpBeforeTest: primeAssetsAndSettle,
      builder: () => buildSingleSliver(
        UserPageHeader(
          data: userPageData.copyWith.relationship!(followingRequested: true),
          notifier: MockUserPageNotifier(),
          isAuthenticatedUser: false,
        ),
      ),
    );

    goldenTest(
      'all metadata',
      fileName: 'user_page_header_all_metadata',
      constraints: phoneConstrains,
      pumpWidget: pumpAppBase,
      pumpBeforeTest: primeAssetsAndSettle,
      builder: () => buildSingleSliver(
        UserPageHeader(
          data: userPageData.copyWith
              .user(location: 'Aincrad')
              .copyWith
              .relationship!(followedBy: true),
          notifier: MockUserPageNotifier(),
          isAuthenticatedUser: false,
        ),
      ),
    );

    goldenTest(
      'translated description',
      fileName: 'user_page_header_translated_description',
      constraints: phoneConstrains,
      pumpWidget: pumpAppBase,
      pumpBeforeTest: primeAssetsAndSettle,
      builder: () => buildSingleSliver(
        UserPageHeader(
          data: userPageData.copyWith(
            descriptionTranslationState: DescriptionTranslationState.translated(
              translation: Translation(
                language: 'German',
                languageCode: 'de',
                original: userDataHarpy.description!,
                text: 'eine Twitter-App mit Flutter entwickelt · '
                    'source-code auf Github erhältlich · '
                    'entwickelt mit ❤️ von @rbydev',
              ),
            ),
          ),
          notifier: MockUserPageNotifier(),
          isAuthenticatedUser: false,
        ),
      ),
    );
  });
}
