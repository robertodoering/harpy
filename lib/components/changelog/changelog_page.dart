import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class ChangelogPage extends ConsumerWidget {
  const ChangelogPage();

  static const name = 'changelog';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HarpyScaffold(
      child: ScrollDirectionListener(
        child: ScrollToTop(
          child: CustomScrollView(
            slivers: [
              const HarpySliverAppBar(title: Text('changelog')),
              ref.watch(changelogProvider).when(
                    data: (changelog) => changelog.isNotEmpty
                        ? _ChangelogList(changelog: changelog)
                        : const SliverFillLoadingError(
                            message: Text('no changelog data found'),
                          ),
                    error: (_, __) => const SliverFillLoadingError(
                      message: Text('no changelog data found'),
                    ),
                    loading: () => const SliverFillLoadingIndicator(),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChangelogList extends StatelessWidget {
  const _ChangelogList({
    required this.changelog,
  });

  final BuiltList<ChangelogData> changelog;

  Widget _itemBuilder(BuildContext context, int index) {
    return index.isEven
        ? Card(child: ChangelogWidget(data: changelog[index ~/ 2]))
        : VerticalSpacer.normal;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverPadding(
      padding: theme.spacing.edgeInsets,
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          _itemBuilder,
          childCount: changelog.length * 2,
        ),
      ),
    );
  }
}
