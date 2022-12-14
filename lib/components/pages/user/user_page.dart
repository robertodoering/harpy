import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/pages/user/widgets/user_page_app_bar.dart';
import 'package:harpy/components/pages/user/widgets/user_page_avatar.dart';
import 'package:harpy/components/pages/user/widgets/user_page_header.dart';
import 'package:harpy/components/pages/user/widgets/user_page_tab_view.dart';
import 'package:rby/rby.dart';
import 'package:sliver_tools/sliver_tools.dart';

class UserPage extends ConsumerWidget {
  const UserPage({
    required this.handle,
  });

  final String handle;

  static const name = 'user';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userPageNotifierProvider(handle));
    final notifier = ref.watch(userPageNotifierProvider(handle).notifier);
    final auth = ref.watch(authenticationStateProvider);

    return HarpyScaffold(
      child: RbyAnimatedSwitcher(
        child: state.when(
          data: (data) => UserPageContent(
            data: data,
            notifier: notifier,
            isAuthenticatedUser: data.user.id == auth.user?.id,
          ),
          error: (_, __) => UserPageError(
            onRetry: () => ref.refresh(userPageNotifierProvider(handle)),
          ),
          loading: () => const UserPageLoading(),
        ),
      ),
    );
  }
}

@visibleForTesting
class UserPageContent extends StatelessWidget {
  const UserPageContent({
    required this.data,
    required this.notifier,
    required this.isAuthenticatedUser,
  });

  final UserPageData data;
  final UserPageNotifier notifier;
  final bool isAuthenticatedUser;

  @override
  Widget build(BuildContext context) {
    return UserPageTabView(
      data: data,
      isAuthenticatedUser: isAuthenticatedUser,
      headerSlivers: [
        SliverStack(
          children: [
            UserPageAppBar(data: data, notifier: notifier),
            if (data.user.profileImage?.original != null)
              UserPageAvatar(url: '${data.user.profileImage!.original}'),

            // display app bar buttons above the avatar
            UserPageAppBarButtons(
              data: data,
              notifier: notifier,
              isAuthenticatedUser: isAuthenticatedUser,
            ),
          ],
        ),
        UserPageHeader(
          data: data,
          notifier: notifier,
          isAuthenticatedUser: isAuthenticatedUser,
        ),
      ],
    );
  }
}

@visibleForTesting
class UserPageError extends StatelessWidget {
  const UserPageError({
    required this.onRetry,
  });

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const HarpySliverAppBar(),
        SliverFillLoadingError(
          message: const Text('error loading user'),
          onRetry: onRetry,
        ),
      ],
    );
  }
}

@visibleForTesting
class UserPageLoading extends StatelessWidget {
  const UserPageLoading();

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        HarpySliverAppBar(),
        SliverFillLoadingIndicator(),
      ],
    );
  }
}
