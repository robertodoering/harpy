import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/misc.dart';

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

  int get _currentVersion =>
      int.tryParse(harpyInfo.packageInfo.buildNumber) ?? 0;

  @override
  void initState() {
    super.initState();

    _initChangelogData();
  }

  Future<void> _initChangelogData() async {
    final List<Future<ChangelogData>> dataFutures =
        List<int>.generate(_currentVersion + 1, (int index) => index)
            .map((int versionCode) => changelogParser.parse(
                  context,
                  '$versionCode',
                ))
            .toList();

    List<ChangelogData> dataList =
        await Future.wait<ChangelogData>(dataFutures);

    dataList = dataList.whereType<ChangelogData>().toList().reversed.toList();

    setState(() {
      _dataList = dataList;
    });
  }

  Widget _buildChangelogWidgets() {
    return ListView.separated(
      padding: DefaultEdgeInsets.only(top: true, bottom: true),
      itemCount: _dataList.length,
      itemBuilder: (BuildContext context, int index) => Padding(
        padding: DefaultEdgeInsets.only(left: true, right: true),
        child: Card(
          child: Padding(
            padding: DefaultEdgeInsets.all(),
            child: ChangelogWidget(_dataList[index]),
          ),
        ),
      ),
      separatorBuilder: (_, __) => defaultVerticalSpacer,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (_dataList == null) {
      child = const Center(child: CircularProgressIndicator());
    } else if (_dataList.isEmpty) {
      child = const Center(child: Text('no changelog data found'));
    } else {
      child = _buildChangelogWidgets();
    }

    return HarpyScaffold(
      title: 'changelog',
      body: child,
    );
  }
}
