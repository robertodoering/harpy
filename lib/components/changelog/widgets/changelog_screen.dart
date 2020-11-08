import 'package:flutter/material.dart';
import 'package:harpy/components/changelog/widgets/changelog_widget.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/core/harpy_info.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/misc/changelog_parser.dart';

class ChangelogScreen extends StatefulWidget {
  const ChangelogScreen();

  static const String route = 'changelog_screen';

  @override
  _ChangelogScreenState createState() => _ChangelogScreenState();
}

class _ChangelogScreenState extends State<ChangelogScreen> {
  final HarpyInfo harpyInfo = app<HarpyInfo>();
  final ChangelogParser changelogParser = app<ChangelogParser>();

  List<ChangelogData> _dataList;

  String get _path {
    final String flavor = Harpy.isFree ? 'free' : 'pro';

    return 'android/fastlane/metadata/android/$flavor/en-US/changelogs/';
  }

  int get _currentVersion =>
      int.tryParse(harpyInfo.packageInfo.buildNumber) ?? 0;

  @override
  void initState() {
    super.initState();

    _initChangelogData();
  }

  Future<void> _initChangelogData() async {
    final List<Future<ChangelogData>> dataFutures =
        List<int>.generate(_currentVersion, (int index) => index)
            .map((int versionCode) => changelogParser.parse('$versionCode'))
            .toList();

    List<ChangelogData> dataList =
        await Future.wait<ChangelogData>(dataFutures);

    dataList = dataList.whereType<ChangelogData>().toList().reversed.toList();

    setState(() {
      _dataList = dataList;
    });
  }

  Widget _buildVersionText(ChangelogData data) {
    // todo: map version code to version string
    return Text('Version ${data.versionCode}');
  }

  Widget _buildChangelogWidgets() {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: _dataList.length,
      itemBuilder: (BuildContext context, int index) {
        final ChangelogData data = _dataList[index];

        return Padding(
          padding: DefaultEdgeInsets.all(),
          child: Column(
            children: <Widget>[
              _buildVersionText(data),
              defaultVerticalSpacer,
              ChangelogWidget(data),
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (_dataList == null) {
      child = const Center(child: CircularProgressIndicator());
    } else if (_dataList.isEmpty) {
      child = const Center(child: Text('No changelog data found'));
    } else {
      child = _buildChangelogWidgets();
    }

    return HarpyScaffold(
      title: 'Changelogs',
      body: child,
    );
  }
}
