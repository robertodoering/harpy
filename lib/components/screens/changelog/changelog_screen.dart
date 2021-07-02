import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

class ChangelogScreen extends StatefulWidget {
  const ChangelogScreen();

  static const String route = 'changelog_screen';

  @override
  _ChangelogScreenState createState() => _ChangelogScreenState();
}

class _ChangelogScreenState extends State<ChangelogScreen> {
  final HarpyInfo? harpyInfo = app<HarpyInfo>();
  final ChangelogParser? changelogParser = app<ChangelogParser>();

  List<ChangelogData?>? _dataList;

  int get _currentVersion =>
      int.tryParse(harpyInfo!.packageInfo!.buildNumber) ?? 0;

  @override
  void initState() {
    super.initState();

    _initChangelogData();
  }

  Future<void> _initChangelogData() async {
    final dataFutures =
        List<int>.generate(_currentVersion + 1, (index) => index)
            .map((versionCode) => changelogParser!.parse(
                  context,
                  '$versionCode',
                ))
            .toList();

    var dataList = await Future.wait<ChangelogData?>(dataFutures);

    dataList = dataList.whereType<ChangelogData>().toList().reversed.toList();

    setState(() {
      _dataList = dataList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigBloc>().state;

    Widget child;

    if (_dataList == null) {
      child = const Center(child: CircularProgressIndicator());
    } else if (_dataList!.isEmpty) {
      child = const Center(child: Text('no changelog data found'));
    } else {
      child = ListView.separated(
        padding: config.edgeInsetsOnly(top: true, bottom: true),
        itemCount: _dataList!.length,
        itemBuilder: (context, index) => Padding(
          padding: config.edgeInsetsOnly(left: true, right: true),
          child: Card(
            child: Padding(
              padding: config.edgeInsets,
              child: ChangelogWidget(_dataList![index]),
            ),
          ),
        ),
        separatorBuilder: (_, __) => defaultVerticalSpacer,
      );
    }

    return HarpyScaffold(
      title: 'changelog',
      body: child,
    );
  }
}
