import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class UserPage extends ConsumerStatefulWidget {
  const UserPage({
    required this.handle,
    this.user,
  });

  final String handle;
  final UserData? user;

  static const name = 'user';

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends ConsumerState<UserPage> {
  late final _connectionsProvider = userConnectionsProvider(
    [widget.handle].toBuiltList(),
  );

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance?.addPostFrameCallback(
      (_) => ref.read(userProvider(widget.handle).notifier).load(widget.user),
    );

    final authenticatedUser = ref.read(authenticationStateProvider).user;

    if (widget.handle != authenticatedUser?.handle) {
      // prevent loading connections for the authenticated user
      ref.read(_connectionsProvider.notifier).load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userProvider(widget.handle));
    final notifier = ref.watch(userProvider(widget.handle).notifier);

    final connections = ref.watch(_connectionsProvider).values.isNotEmpty
        ? ref.watch(_connectionsProvider).values.first
        : null;
    final connectionsNotifier = ref.watch(_connectionsProvider.notifier);

    return HarpyScaffold(
      child: state.when(
        data: (user) => UserTabView(
          user: user,
          headerSlivers: [
            UserAppBar(user: user),
            UserHeader(
              user: user,
              notifier: notifier,
              connections: connections,
              connectionsNotifier: connectionsNotifier,
            ),
          ],
        ),
        error: (_, __) => CustomScrollView(
          slivers: [
            const HarpySliverAppBar(),
            SliverFillLoadingError(
              message: const Text('error loading user'),
              onRetry: notifier.load,
            ),
          ],
        ),
        loading: () => const CustomScrollView(
          slivers: [
            HarpySliverAppBar(),
            SliverFillLoadingIndicator(),
          ],
        ),
      ),
    );
  }
}
