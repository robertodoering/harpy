import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class HomeTopPadding extends ConsumerWidget {
  const HomeTopPadding();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final general = ref.watch(generalPreferencesProvider);

    return general.bottomAppBar
        ? SizedBox(height: mediaQuery.padding.top)
        : SizedBox(height: HomeAppBar.height(ref));
  }
}

class HomeTopSliverPadding extends StatelessWidget {
  const HomeTopSliverPadding();

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: HomeTopPadding(),
    );
  }
}

class HomeBottomPadding extends ConsumerWidget {
  const HomeBottomPadding();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final general = ref.watch(generalPreferencesProvider);

    return general.bottomAppBar
        ? SizedBox(height: HomeAppBar.height(ref))
        : SizedBox(height: mediaQuery.padding.bottom);
  }
}

class HomeBottomSliverPadding extends StatelessWidget {
  const HomeBottomSliverPadding();

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: HomeBottomPadding(),
    );
  }
}
