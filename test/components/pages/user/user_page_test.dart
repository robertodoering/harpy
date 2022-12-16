import 'package:alchemist/alchemist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:mocktail/mocktail.dart';

import '../../../test_setup/data/user_data.dart';
import '../../../test_setup/setup.dart';

class MockUserPageNotifier extends Mock implements UserPageNotifier {}

// TODO: fake impl should extend Notifier after refactoring the timeline
//  notifiers

class FakeUserTimelineNotifier extends UserTimelineNotifier {
  FakeUserTimelineNotifier({
    required super.ref,
    required super.twitterApi,
    required super.userId,
  }) {
    state = const TimelineStateInitial();
  }
}

final userTimelineNotifierOverride = userTimelineProvider.overrideWith(
  (ref, arg) => FakeUserTimelineNotifier(
    ref: ref,
    twitterApi: MockTwitterApiV1(),
    userId: '',
  ),
);

final userPageData = UserPageData(
  user: userDataHarpy,
  bannerUrl: 'user_banner.png',
  relationship: const RelationshipData(),
);

void main() {
  setUpAll(loadAppFonts);

  group('$UserPage', () {
    goldenTest(
      '$UserPageContent',
      fileName: 'user_page_content',
      constraints: phoneConstrains,
      pumpWidget: (tester, widget) => pumpAppBase(
        tester,
        widget,
        overrides: [
          userTimelineNotifierOverride,
        ],
      ),
      pumpBeforeTest: primeAssetsAndSettle,
      builder: () => UserPageContent(
        data: userPageData,
        notifier: MockUserPageNotifier(),
        isAuthenticatedUser: false,
      ),
    );

    goldenTest(
      '$UserPageContent for protected user',
      fileName: 'user_page_content_protected',
      constraints: phoneConstrains,
      pumpWidget: (tester, widget) => pumpAppBase(
        tester,
        widget,
        overrides: [
          userTimelineNotifierOverride,
        ],
      ),
      pumpBeforeTest: primeAssetsAndSettle,
      builder: () => UserPageContent(
        data: userPageData.copyWith.user(isProtected: true),
        notifier: MockUserPageNotifier(),
        isAuthenticatedUser: false,
      ),
    );

    goldenTest(
      '$UserPageContent for authenticated user',
      fileName: 'user_page_content_authenticated_user',
      constraints: phoneConstrains,
      pumpWidget: (tester, widget) => pumpAppBase(
        tester,
        widget,
        overrides: [
          userTimelineNotifierOverride,
        ],
      ),
      pumpBeforeTest: primeAssetsAndSettle,
      builder: () => UserPageContent(
        data: userPageData,
        notifier: MockUserPageNotifier(),
        isAuthenticatedUser: true,
      ),
    );

    goldenTest(
      '$UserPageError',
      fileName: 'user_page_error',
      constraints: phoneConstrains,
      pumpWidget: pumpAppBase,
      builder: () => UserPageError(onRetry: () {}),
    );

    goldenTest(
      '$UserPageLoading',
      fileName: 'user_page_loading',
      constraints: phoneConstrains,
      pumpWidget: pumpAppBase,
      pumpBeforeTest: (tester) async {
        // await the implicit opacity animation that triggers when building the
        // widget
        await tester.pump(Duration.zero);
        await tester.pump(const Duration(milliseconds: 250));
      },
      builder: () => const UserPageLoading(),
    );
  });
}
