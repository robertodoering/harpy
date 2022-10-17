import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class TimelineFilterCreation extends ConsumerStatefulWidget {
  const TimelineFilterCreation({
    this.initialTimelineFilter,
    this.onSaved,
  });

  /// The existing filter used to update existing filters.
  ///
  /// `null` when a new filter should be created instead.
  final TimelineFilter? initialTimelineFilter;

  final ValueChanged<TimelineFilter>? onSaved;

  static const name = 'timeline_filter_creation';

  @override
  ConsumerState<TimelineFilterCreation> createState() =>
      _TimelineFilterCreationState();
}

class _TimelineFilterCreationState
    extends ConsumerState<TimelineFilterCreation> {
  late final TimelineFilter _initialTimelineFilter;

  @override
  void initState() {
    super.initState();

    _initialTimelineFilter =
        widget.initialTimelineFilter ?? TimelineFilter.empty();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filter = ref.watch(
      timelineFilterCreationProvider(_initialTimelineFilter),
    );
    final notifier = ref.watch(
      timelineFilterCreationProvider(_initialTimelineFilter).notifier,
    );

    return _WillPopFilterCreation(
      notifier: notifier,
      child: HarpyScaffold(
        child: CustomScrollView(
          slivers: [
            HarpySliverAppBar(
              title: const Text('timeline filter creation'),
              actions: [
                _SaveFilterAction(
                  initialTimelineFilter: _initialTimelineFilter,
                  notifier: notifier,
                  isEditing: widget.initialTimelineFilter != null,
                  onSaved: widget.onSaved,
                ),
              ],
            ),
            SliverPadding(
              padding: theme.spacing.edgeInsets,
              sliver: _FilterGroups(
                filter: filter,
                notifier: notifier,
              ),
            ),
            const SliverBottomPadding(),
          ],
        ),
      ),
    );
  }
}

class _SaveFilterAction extends ConsumerWidget {
  const _SaveFilterAction({
    required this.initialTimelineFilter,
    required this.notifier,
    required this.isEditing,
    required this.onSaved,
  });

  final TimelineFilter initialTimelineFilter;
  final TimelineFilterCreationNotifier notifier;
  final bool isEditing;
  final ValueChanged<TimelineFilter>? onSaved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timelineFilterNotifier = ref.watch(timelineFilterProvider.notifier);

    return RbyButton.transparent(
      icon: const Icon(FeatherIcons.check),
      onTap: notifier.valid
          ? () {
              final filter = ref.read(
                timelineFilterCreationProvider(initialTimelineFilter),
              );

              if (isEditing) {
                timelineFilterNotifier.updateTimelineFilter(filter);
              } else {
                timelineFilterNotifier.addTimelineFilter(filter);
              }

              onSaved?.call(filter);

              Navigator.of(context).pop();
            }
          : null,
    );
  }
}

class _FilterGroups extends StatelessWidget {
  const _FilterGroups({
    required this.filter,
    required this.notifier,
  });

  final TimelineFilter filter;
  final TimelineFilterCreationNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        _FilterName(
          notifier: notifier,
          initialName: filter.name,
        ),
        VerticalSpacer.normal,
        ExpansionCard(
          title: const Text('includes'),
          children: [
            FilterSwitchTile(
              text: 'image(s)',
              value: filter.includes.image,
              onChanged: notifier.updateIncludeImages,
            ),
            FilterSwitchTile(
              text: 'gif',
              value: filter.includes.gif,
              onChanged: notifier.updateIncludeGif,
            ),
            FilterSwitchTile(
              text: 'video',
              value: filter.includes.video,
              onChanged: notifier.updateIncludeVideo,
            ),
            VerticalSpacer.normal,
            FilterListEntry(
              labelText: 'keyword / phrase',
              activeFilters: filter.includes.phrases,
              onSubmitted: notifier.addIncludingPhrase,
              onDeleted: notifier.removeIncludingPhrase,
            ),
            VerticalSpacer.normal,
            FilterListEntry(
              labelText: 'hashtags',
              activeFilters: filter.includes.hashtags,
              onSubmitted: notifier.addIncludingHashtags,
              onDeleted: notifier.removeIncludingHashtags,
            ),
            VerticalSpacer.normal,
            FilterListEntry(
              labelText: 'mentions',
              activeFilters: filter.includes.mentions,
              onSubmitted: notifier.addIncludingMentions,
              onDeleted: notifier.removeIncludingMentions,
            ),
            VerticalSpacer.normal,
          ],
        ),
        VerticalSpacer.normal,
        ExpansionCard(
          title: const Text('excludes'),
          children: [
            FilterSwitchTile(
              text: 'replies',
              value: filter.excludes.replies,
              onChanged: notifier.updateExcludeReplies,
            ),
            FilterSwitchTile(
              text: 'retweets',
              value: filter.excludes.retweets,
              onChanged: notifier.updateExcludeRetweets,
            ),
            VerticalSpacer.normal,
            FilterListEntry(
              labelText: 'keyword / phrase',
              activeFilters: filter.excludes.phrases,
              onSubmitted: notifier.addExcludingPhrase,
              onDeleted: notifier.removeExcludingPhrase,
            ),
            VerticalSpacer.normal,
            FilterListEntry(
              labelText: 'hashtags',
              activeFilters: filter.excludes.hashtags,
              onSubmitted: notifier.addExcludingHashtags,
              onDeleted: notifier.removeExcludingHashtags,
            ),
            VerticalSpacer.normal,
            FilterListEntry(
              labelText: 'mentions',
              activeFilters: filter.excludes.mentions,
              onSubmitted: notifier.addExcludingMentions,
              onDeleted: notifier.removeExcludingMentions,
            ),
            VerticalSpacer.normal,
          ],
        ),
      ]),
    );
  }
}

class _FilterName extends StatefulWidget {
  const _FilterName({
    required this.notifier,
    required this.initialName,
  });

  final TimelineFilterCreationNotifier notifier;
  final String initialName;

  @override
  State<_FilterName> createState() => _FilterNameState();
}

class _FilterNameState extends State<_FilterName> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.notifier.updateName,
      maxLength: 30,
      decoration: InputDecoration(
        errorText: _controller.text.isEmpty ? 'enter a name' : null,
      ),
    );
  }
}

class _WillPopFilterCreation extends StatelessWidget {
  const _WillPopFilterCreation({
    required this.notifier,
    required this.child,
  });

  final TimelineFilterCreationNotifier notifier;
  final Widget child;

  Future<bool> _onWillPop(BuildContext context) async {
    if (notifier.modified) {
      // ask to discard changes before exiting
      final discard = await showDialog<bool>(
        context: context,
        builder: (_) => RbyDialog(
          title: const Text('discard changes?'),
          actions: [
            RbyButton.text(
              label: const Text('cancel'),
              onTap: Navigator.of(context).pop,
            ),
            RbyButton.text(
              label: const Text('discard'),
              onTap: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      );

      return discard ?? false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: child,
    );
  }
}
