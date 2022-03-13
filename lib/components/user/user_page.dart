import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/components/user/widgets/header/user_header.dart';

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
  @override
  void initState() {
    super.initState();

    ref.read(userProvider(widget.handle).notifier).load(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userProvider(widget.handle));
    final notifier = ref.watch(userProvider(widget.handle).notifier);

    return HarpyScaffold(
      child: CustomScrollView(
        slivers: [
          ...state.when(
            data: (user) => [
              UserAppBar(user: user),
              UserHeader(user: user),
            ],
            error: (_, __) => [
              SliverFillLoadingError(
                message: const Text('error loading user'),
                onRetry: notifier.load,
              ),
            ],
            loading: () => [
              const HarpySliverAppBar(),
              const SliverFillLoadingIndicator(),
            ],
          ),
        ],
      ),
    );
  }
}
