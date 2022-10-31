import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage();

  static const name = 'home';

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();

    ChangelogDialog.maybeShow(ref);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mentionsTimelineProvider.notifier).load(clearPrevious: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const WillPopHarpy(
      child: HarpyScaffold(
        child: ScrollDirectionListener(
          depth: 1,
          child: HomeTabView(),
        ),
      ),
    );
  }
}
