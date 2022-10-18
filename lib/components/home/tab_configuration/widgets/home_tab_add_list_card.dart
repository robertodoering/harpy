import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

class HomeTabAddListCard extends ConsumerWidget {
  const HomeTabAddListCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authentication = ref.watch(authenticationStateProvider);
    final notifier = ref.watch(homeTabConfigurationProvider.notifier);
    final launcher = ref.watch(launcherProvider);

    return RbyListCard(
      color: Colors.transparent,
      leading: const Icon(CupertinoIcons.add),
      title: const Text(isFree ? 'add lists with harpy pro' : 'add list'),
      trailing: isFree ? const FlareIcon.shiningStar() : null,
      border: Border.all(color: theme.dividerColor),
      onTap: isFree
          ? () => launcher(
                'https://play.google.com/store/apps/details?id=com.robertodoering.harpy.pro',
              )
          : () => context.pushNamed(
                ListShowPage.name,
                params: {'handle': authentication.user!.handle},
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
