import 'package:flutter/material.dart';
import 'package:harpy/misc/changelog_parser.dart';

/// Builds the changelog widget for the [data].
class ChangelogWidget extends StatelessWidget {
  const ChangelogWidget(this.data);

  final ChangelogData data;

  Widget _spacedColumn(List<Widget> children) {
    return Column(
      children: <Widget>[
        for (Widget child in children) ...<Widget>[
          child,
          if (child != children.last) const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildHeaderText() {
    return Column(
      children: <Widget>[
        for (String headerLine in data.headerLines) ...<Widget>[
          Text(headerLine),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildEntry(ChangelogEntry entry, Widget icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        icon,
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(entry.line, textAlign: TextAlign.left),
              if (entry.additionalInfo.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 12),
                  child: _buildAdditionalInformation(entry.additionalInfo),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInformation(List<String> additionalInformation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (String line in additionalInformation) ...<Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('·'),
              const SizedBox(width: 12),
              Expanded(child: Text('$line', textAlign: TextAlign.left)),
            ],
          ),
          if (line != additionalInformation.last) const SizedBox(height: 6),
        ]
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> additions = data.additions
        .map((ChangelogEntry entry) =>
            _buildEntry(entry, const Icon(Icons.adjust, color: Colors.green)))
        .toList();

    final List<Widget> changes = data.changes
        .map((ChangelogEntry entry) =>
            _buildEntry(entry, const Icon(Icons.adjust, color: Colors.yellow)))
        .toList();

    final List<Widget> fixes = data.fixes
        .map((ChangelogEntry entry) =>
            _buildEntry(entry, const Icon(Icons.adjust, color: Colors.orange)))
        .toList();

    final List<Widget> removals = data.removals
        .map((ChangelogEntry entry) =>
            _buildEntry(entry, const Icon(Icons.adjust, color: Colors.red)))
        .toList();

    final List<Widget> others = data.others
        .map((ChangelogEntry entry) =>
            _buildEntry(entry, const Icon(Icons.adjust, color: Colors.blue)))
        .toList();

    return _spacedColumn(<Widget>[
      if (data.headerLines != null) _buildHeaderText(),
      if (additions.isNotEmpty) _spacedColumn(additions),
      if (changes.isNotEmpty) _spacedColumn(changes),
      if (fixes.isNotEmpty) _spacedColumn(fixes),
      if (removals.isNotEmpty) _spacedColumn(removals),
      if (others.isNotEmpty) _spacedColumn(others),
    ]);
  }
}
