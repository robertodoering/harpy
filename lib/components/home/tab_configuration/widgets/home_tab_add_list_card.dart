import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

class HomeTabAddListCard extends ConsumerWidget {
  const HomeTabAddListCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final router = ref.watch(routerProvider);
    final authentication = ref.watch(authenticationStateProvider);
    final notifier = ref.watch(homeTabConfigurationProvider.notifier);

    return HarpyListCard(
      color: Colors.transparent,
      leading: const Icon(CupertinoIcons.add),
      title: const Text(isFree ? 'add lists with harpy pro' : 'add list'),
      trailing: isFree ? const FlareIcon.shiningStar() : null,
      border: Border.all(color: theme.dividerColor),
      onTap: isFree
          ? () => safeLaunchUrl(
                'https://play.google.com/store/apps/details?id=com.robertodoering.harpy.pro',
              )
          : () => router.pushNamed(
                ListShowPage.name,
                params: {'userId': authentication.user!.id},
                // ignore: avoid_types_on_closure_parameters
                extra: (TwitterListData list) {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pop();
                  notifier.addList(list: list);
                },
              ),
    );
  }
}
