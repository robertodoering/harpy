import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

class ChangelogScreen extends StatefulWidget {
  const ChangelogScreen();

  static const route = 'changelog';

  @override
  _ChangelogScreenState createState() => _ChangelogScreenState();
}

class _ChangelogScreenState extends State<ChangelogScreen> {
  BuiltList<ChangelogData>? _dataList;

  @override
  void initState() {
    super.initState();

    _initChangelogData();
  }

  Future<void> _initChangelogData() async {
    final currentVersion =
        int.tryParse(app<HarpyInfo>().packageInfo?.buildNumber ?? '0') ?? 0;

    final dataList = await Future.wait(
      List<int>.generate(currentVersion + 1, (index) => index).map(
        (versionCode) => app<ChangelogParser>().parse(
          context,
          '$versionCode',
        ),
      ),
    );

    setState(() {
      _dataList =
          dataList.whereType<ChangelogData>().toList().reversed.toBuiltList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

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
        separatorBuilder: (_, __) => verticalSpacer,
      );
    }

    return HarpyScaffold(
      title: 'changelog',
      body: child,
    );
  }
}
