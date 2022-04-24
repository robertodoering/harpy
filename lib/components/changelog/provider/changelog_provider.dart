import 'package:built_collection/built_collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

final currentChangelogProvider = FutureProvider.autoDispose(
  (ref) async {
    final buildNumber = ref.watch(deviceInfoProvider).packageInfo?.buildNumber;

    return buildNumber != null
        ? await ref
            .watch(changelogParserProvider)
            .parse(buildNumber: buildNumber)
        : null;
  },
  name: 'CurrentChangelogProvider',
);

final changelogProvider = FutureProvider.autoDispose(
  (ref) async {
    final buildNumber = ref.watch(deviceInfoProvider).packageInfo?.buildNumber;
    final buildNumberInt = int.tryParse(buildNumber ?? '0') ?? 0;

    final changelog = await Future.wait(
      List<int>.generate(buildNumberInt + 1, (index) => index).reversed.map(
            (buildNumberInt) => ref
                .watch(changelogParserProvider)
                .parse(buildNumber: '$buildNumberInt'),
          ),
    );

    return changelog.whereType<ChangelogData>().toBuiltList();
  },
  name: 'ChangelogProvider',
);
