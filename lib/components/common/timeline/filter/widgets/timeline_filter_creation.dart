import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class TimelineFilterCreation extends StatelessWidget {
  const TimelineFilterCreation({
    this.timelineFilter,
  });

  /// The existing filter used to update existing filters.
  ///
  /// `null` when a new filter should be created instead.
  final TimelineFilter? timelineFilter;

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return BlocProvider(
      create: (_) => TimelineFilterCreationCubit(
        timelineFilter: timelineFilter ?? TimelineFilter.empty(),
      ),
      child: _WillPopFilterCreation(
        child: GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: HarpyScaffold(
            body: CustomScrollView(
              slivers: [
                HarpySliverAppBar(
                  title: 'timeline filter creation',
                  floating: true,
                  actions: [
                    _SaveFilterAction(isEditing: timelineFilter != null),
                  ],
                ),
                SliverPadding(
                  padding: config.edgeInsets,
                  sliver: const _FilterGroups(),
                ),
                const SliverBottomPadding(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SaveFilterAction extends StatelessWidget {
  const _SaveFilterAction({
    required this.isEditing,
  });

  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    final timelineFilterCubit = context.watch<TimelineFilterCubit>();
    final cubit = context.watch<TimelineFilterCreationCubit>();

    return HarpyButton.flat(
      padding: const EdgeInsets.all(16),
      icon: const Icon(FeatherIcons.check),
      onTap: cubit.valid
          ? () {
              if (isEditing) {
                timelineFilterCubit.updateTimelineFilter(cubit.state);
              } else {
                timelineFilterCubit.addTimelineFilter(cubit.state);
              }
              Navigator.of(context).pop();
            }
          : null,
    );
  }
}

class _FilterGroups extends StatelessWidget {
  const _FilterGroups();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TimelineFilterCreationCubit>();
    final timelineFilter = cubit.state;

    return SliverList(
      delegate: SliverChildListDelegate([
        _FilterName(initialName: timelineFilter.name),
        verticalSpacer,
        ExpansionCard(
          title: const Text('includes'),
          children: [
            FilterSwitchTile(
              text: 'image(s)',
              value: timelineFilter.includes.image,
              onChanged: cubit.updateIncludeImages,
            ),
            FilterSwitchTile(
              text: 'gif',
              value: timelineFilter.includes.gif,
              onChanged: cubit.updateIncludeGif,
            ),
            FilterSwitchTile(
              text: 'video',
              value: timelineFilter.includes.video,
              onChanged: cubit.updateIncludeVideo,
            ),
            verticalSpacer,
            FilterListEntry(
              labelText: 'keyword / phrase',
              activeFilters: timelineFilter.includes.phrases,
              onSubmitted: cubit.addIncludingPhrase,
              onDeleted: cubit.removeIncludingPhrase,
            ),
            verticalSpacer,
            FilterListEntry(
              labelText: 'hashtags',
              activeFilters: timelineFilter.includes.hashtags,
              onSubmitted: cubit.addIncludingHashtags,
              onDeleted: cubit.removeIncludingHashtags,
            ),
            verticalSpacer,
            FilterListEntry(
              labelText: 'mentions',
              activeFilters: timelineFilter.includes.mentions,
              onSubmitted: cubit.addIncludingMentions,
              onDeleted: cubit.removeIncludingMentions,
            ),
            verticalSpacer,
          ],
        ),
        verticalSpacer,
        ExpansionCard(
          title: const Text('excludes'),
          children: [
            FilterSwitchTile(
              text: 'replies',
              value: timelineFilter.excludes.replies,
              onChanged: cubit.updateExcludeReplies,
            ),
            FilterSwitchTile(
              text: 'retweets',
              value: timelineFilter.excludes.retweets,
              onChanged: cubit.updateExcludeRetweets,
            ),
            verticalSpacer,
            FilterListEntry(
              labelText: 'keyword / phrase',
              activeFilters: timelineFilter.excludes.phrases,
              onSubmitted: cubit.addExcludingPhrase,
              onDeleted: cubit.removeExcludingPhrase,
            ),
            verticalSpacer,
            FilterListEntry(
              labelText: 'hashtags',
              activeFilters: timelineFilter.excludes.hashtags,
              onSubmitted: cubit.addExcludingHashtags,
              onDeleted: cubit.removeExcludingHashtags,
            ),
            verticalSpacer,
            FilterListEntry(
              labelText: 'mentions',
              activeFilters: timelineFilter.excludes.mentions,
              onSubmitted: cubit.addExcludingMentions,
              onDeleted: cubit.removeExcludingMentions,
            ),
            verticalSpacer,
          ],
        ),
      ]),
    );
  }
}

class _FilterName extends StatefulWidget {
  const _FilterName({
    required this.initialName,
  });

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
    final cubit = context.watch<TimelineFilterCreationCubit>();

    return TextField(
      controller: _controller,
      onChanged: cubit.updateName,
      maxLength: 30,
      decoration: InputDecoration(
        errorText: _controller.text.isEmpty ? 'enter a name' : null,
      ),
    );
  }
}

class _WillPopFilterCreation extends StatelessWidget {
  const _WillPopFilterCreation({
    required this.child,
  });

  final Widget child;

  Future<bool> _onWillPop(
    BuildContext context, {
    required TimelineFilterCreationCubit cubit,
  }) async {
    var pop = true;

    if (cubit.modified) {
      // ask to discard changes before exiting
      final discard = await showDialog<bool>(
        context: context,
        builder: (_) => const HarpyDialog(
          title: Text('discard changes?'),
          actions: [
            DialogAction(result: false, text: 'cancel'),
            DialogAction(result: true, text: 'discard'),
          ],
        ),
      );

      pop = discard ?? false;
    }

    if (pop) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TimelineFilterCreationCubit>();

    return WillPopScope(
      onWillPop: () => _onWillPop(context, cubit: cubit),
      child: child,
    );
  }
}
