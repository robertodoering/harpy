import 'package:flutter/material.dart';
import 'package:harpy/components/common/dialogs/harpy_dialog.dart';
import 'package:harpy/core/harpy_info.dart';
import 'package:harpy/core/preferences/changelog_preferences.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/misc/changelog_parser.dart';
import 'package:harpy/misc/harpy_navigator.dart';

class ChangelogDialog extends StatefulWidget {
  const ChangelogDialog();

  static Future<void> show(BuildContext context) async {
    final ChangelogPreferences changelogPreferences =
        app<ChangelogPreferences>();
    final HarpyInfo harpyInfo = app<HarpyInfo>();

    // set last shown version to current version when
    changelogPreferences.lastShownVersion =
        int.tryParse(harpyInfo.packageInfo.buildNumber) ?? 0;

    await Future<void>.delayed(Duration.zero);

    showDialog<void>(
      context: context,
      child: const ChangelogDialog(),
    );
  }

  @override
  _ChangelogDialogState createState() => _ChangelogDialogState();
}

class _ChangelogDialogState extends State<ChangelogDialog> {
  @override
  Widget build(BuildContext context) {
    return HarpyDialog(
      title: const Text('Whats new?'),
      contentPadding: const EdgeInsets.only(top: 24, left: 24, right: 24),
      content: Column(
        children: <Widget>[
          const ChangelogWidget.current(),
          const SizedBox(height: 24),
          CheckboxListTile(
            value: false,
            title: Text(
              "Don't show this again",
              style: Theme.of(context).textTheme.subtitle2,
            ),
            onChanged: (bool value) {
              // todo: implement
            },
          ),
        ],
      ),
      actions: <Widget>[
        DialogAction<void>(
          text: 'Ok',
          onTap: () => app<HarpyNavigator>().state.maybePop(),
        )
      ],
    );
  }
}

class ChangelogWidget extends StatefulWidget {
  const ChangelogWidget({
    @required this.versionCode,
    this.version,
  });

  const ChangelogWidget.current()
      : versionCode = null,
        version = null;

  final String versionCode;
  final String version;

  @override
  _ChangelogWidgetState createState() => _ChangelogWidgetState();
}

class _ChangelogWidgetState extends State<ChangelogWidget> {
  Future<ChangelogData> _changelogData;

  String _version;

  @override
  void initState() {
    super.initState();

    if (widget.versionCode == null) {
      _changelogData = app<ChangelogParser>().current();
      _version = app<HarpyInfo>().packageInfo.version;
    } else {
      _changelogData = app<ChangelogParser>().parse(widget.versionCode);
      _version = widget.version;
    }
  }

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

  Widget _buildVersionText() {
    final String flavor = Harpy.isFree ? 'Free' : 'Pro';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text('Harpy $flavor $_version'),
    );
  }

  Widget _buildChangelogData(ChangelogData data) {
    final List<Widget> additions = data.additions
        .map((ChangelogEntry entry) =>
            _buildEntry(entry, const Icon(Icons.add, color: Colors.green)))
        .toList();

    final List<Widget> changes = data.changes
        .map((ChangelogEntry entry) => _buildEntry(
            entry, const Icon(Icons.compare_arrows, color: Colors.yellow)))
        .toList();

    final List<Widget> fixes = data.fixes
        .map((ChangelogEntry entry) => _buildEntry(
            entry, const Icon(Icons.bug_report_outlined, color: Colors.green)))
        .toList();

    final List<Widget> removals = data.removals
        .map((ChangelogEntry entry) =>
            _buildEntry(entry, const Icon(Icons.remove, color: Colors.red)))
        .toList();

    final List<Widget> others = data.others
        .map((ChangelogEntry entry) => _buildEntry(
            entry, const Icon(Icons.info_outline, color: Colors.yellow)))
        .toList();

    return _spacedColumn(<Widget>[
      _buildVersionText(),
      if (additions.isNotEmpty) _spacedColumn(additions),
      if (changes.isNotEmpty) _spacedColumn(changes),
      if (fixes.isNotEmpty) _spacedColumn(fixes),
      if (removals.isNotEmpty) _spacedColumn(removals),
      if (others.isNotEmpty) _spacedColumn(others),
    ]);
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
    return FutureBuilder<ChangelogData>(
      future: _changelogData,
      builder: (BuildContext context, AsyncSnapshot<ChangelogData> snapshot) {
        if (snapshot.hasData) {
          return _buildChangelogData(snapshot.data);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          return const Text('No changelog found');
        }
      },
    );
  }
}
