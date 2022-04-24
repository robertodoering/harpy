import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class ChangelogWidget extends ConsumerWidget {
  const ChangelogWidget({
    required this.data,
  });

  final ChangelogData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    return Padding(
      padding: display.edgeInsets,
      child: Column(
        children: [
          if (data.title != null) ...[
            Text(
              data.title!,
              style: theme.textTheme.subtitle1,
            ),
            verticalSpacer,
          ],
          if (data.date != null) ...[
            _ChangelogDate(date: data.date!),
            verticalSpacer,
          ],
          if (data.summary.isNotEmpty) ...[
            _ChangelogSummary(summary: data.summary),
            verticalSpacer,
          ],
          for (final entry in data.entries) ...[
            _ChangelogEntry(entry: entry),
            if (entry != data.entries.last) smallVerticalSpacer,
          ],
        ],
      ),
    );
  }
}

class _ChangelogDate extends StatelessWidget {
  const _ChangelogDate({
    required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = Localizations.of<MaterialLocalizations>(
      context,
      MaterialLocalizations,
    )!;

    return Text(
      l10n.formatShortDate(date.toLocal()),
      style: theme.textTheme.subtitle2,
    );
  }
}

class _ChangelogSummary extends StatelessWidget {
  const _ChangelogSummary({
    required this.summary,
  });

  final BuiltList<String> summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final line in summary) ...[
          HarpyMarkdown(line),
          if (line != summary.last) smallVerticalSpacer,
        ],
      ],
    );
  }
}

class _ChangelogEntry extends StatelessWidget {
  const _ChangelogEntry({
    required this.entry,
  });

  final ChangelogEntry entry;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: entry.type.asIcon,
        ),
        horizontalSpacer,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.line),
              if (entry.subEntries.isNotEmpty)
                Column(
                  children: [
                    for (final subEntry in entry.subEntries) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('·'),
                          smallHorizontalSpacer,
                          Expanded(child: HarpyMarkdown(subEntry.line)),
                        ],
                      ),
                      if (subEntry != entry.subEntries.last)
                        smallVerticalSpacer,
                    ],
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

extension on ChangelogEntryType {
  Widget get asIcon {
    switch (this) {
      case ChangelogEntryType.added:
      case ChangelogEntryType.improved:
        return const Icon(CupertinoIcons.plus_circled, color: Colors.green);
      case ChangelogEntryType.changed:
      case ChangelogEntryType.updated:
        return const Icon(
          CupertinoIcons.smallcircle_fill_circle,
          color: Colors.yellow,
        );
      case ChangelogEntryType.fixed:
        return const Icon(
          CupertinoIcons.smallcircle_fill_circle,
          color: Colors.orange,
        );
      case ChangelogEntryType.removed:
        return const Icon(CupertinoIcons.minus_circled, color: Colors.red);
      case ChangelogEntryType.other:
        return const Icon(
          CupertinoIcons.smallcircle_fill_circle,
          color: Colors.blue,
        );
    }
  }
}
