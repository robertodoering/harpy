import 'dart:convert';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

part 'download_path_provider.freezed.dart';
part 'download_path_provider.g.dart';

final downloadPathProvider =
    StateNotifierProvider<DownloadPathNotifier, DownloadPathState>(
  (ref) => DownloadPathNotifier(ref: ref),
  name: 'DownloadPathProvider',
);

class DownloadPathNotifier extends StateNotifier<DownloadPathState>
    with LoggerMixin {
  DownloadPathNotifier({required Ref ref})
      : _ref = ref,
        super(const DownloadPathState.loading());

  final Ref _ref;

  Future<void> initialize() async {
    state = const DownloadPathState.loading();

    final mediaPaths = await _mediaPaths();

    if (!mounted) return;

    if (mediaPaths == null) {
      state = const DownloadPathState.error();
      return;
    }

    final downloadPathData =
        _ref.read(mediaPreferencesProvider).downloadPathData;

    if (downloadPathData.isEmpty) {
      // use default
      state = DownloadPathState.data(
        mediaPaths: mediaPaths,
        entries: _defaultEntries(mediaPaths),
      );
    } else {
      try {
        final json = jsonDecode(downloadPathData) as Map<String, dynamic>;

        final data = DownloadPathData.fromJson(json);

        final entries = data.entries
            .where((entry) => mediaPaths.contains(entry.path))
            .toBuiltList();

        state = DownloadPathState.data(
          mediaPaths: mediaPaths,
          entries: entries,
        );
      } catch (e, st) {
        log.severe('error decoding downloda path data', e, st);

        // reset saved preferences and use default
        _ref.read(mediaPreferencesProvider.notifier).setDownloadPathData('');

        state = DownloadPathState.data(
          mediaPaths: mediaPaths,
          entries: _defaultEntries(mediaPaths),
        );
      }
    }
  }

  void updateEntry({
    required String type,
    required String path,
    required String subDir,
  }) {
    final currentState = state;

    if (currentState is _Data) {
      final entries = currentState.entries.toList();

      final index = entries.indexWhere((entry) => entry.type == type);

      if (index != -1) {
        entries[index] = DownloadPathEntry(
          type: type,
          path: path,
          subDir: subDir,
        );

        try {
          _ref.read(mediaPreferencesProvider.notifier).setDownloadPathData(
                jsonEncode(DownloadPathData(entries: entries).toJson()),
              );

          state = currentState.copyWith(entries: entries.toBuiltList());
        } catch (e, st) {
          log.severe('error persisting download data', e, st);
        }
      }
    }
  }
}

@freezed
class DownloadPathState with _$DownloadPathState {
  const factory DownloadPathState.loading() = _Loading;

  const factory DownloadPathState.data({
    required BuiltList<String> mediaPaths,
    required BuiltList<DownloadPathEntry> entries,
  }) = _Data;

  const factory DownloadPathState.error() = _Error;
}

extension DownloadPathStateExtension on DownloadPathState {
  String? get imageFullPath => mapOrNull<String?>(
        data: (data) => data.entries
            .firstWhereOrNull((entry) => entry.type == 'image')
            ?.fullPath,
      );

  String? get gifFullPath => mapOrNull<String?>(
        data: (data) => data.entries
            .firstWhereOrNull((entry) => entry.type == 'gif')
            ?.fullPath,
      );

  String? get videoFullPath => mapOrNull<String?>(
        data: (data) => data.entries
            .firstWhereOrNull((entry) => entry.type == 'video')
            ?.fullPath,
      );

  String? fullPathForType(MediaType type) => whenOrNull<String?>(
        data: (mediaPaths, entries) {
          switch (type) {
            case MediaType.image:
              return imageFullPath;
            case MediaType.gif:
              return gifFullPath;
            case MediaType.video:
              return videoFullPath;
          }
        },
      );
}

@freezed
class DownloadPathData with _$DownloadPathData {
  const factory DownloadPathData({
    required List<DownloadPathEntry> entries,
  }) = _DownloadPathData;

  factory DownloadPathData.fromJson(Map<String, dynamic> json) =>
      _$DownloadPathDataFromJson(json);
}

@freezed
class DownloadPathEntry with _$DownloadPathEntry {
  factory DownloadPathEntry({
    required String type,
    required String path,
    required String subDir,
  }) = _Entry;

  DownloadPathEntry._();

  factory DownloadPathEntry.fromJson(Map<String, dynamic> json) =>
      _$DownloadPathEntryFromJson(json);

  late final fullPath = '$path${subDir.isNotEmpty ? "/$subDir" : ""}';
}

BuiltList<DownloadPathEntry> _defaultEntries(BuiltList<String> mediaPaths) {
  return [
    DownloadPathEntry(
      type: 'image',
      path: mediaPaths[0],
      subDir: 'harpy',
    ),
    DownloadPathEntry(
      type: 'gif',
      path: mediaPaths[0],
      subDir: 'harpy',
    ),
    DownloadPathEntry(
      type: 'video',
      path: mediaPaths[0],
      subDir: 'harpy',
    ),
  ].toBuiltList();
}

Future<BuiltList<String>?> _mediaPaths() async {
  // The order determines the display order and fallback behavior.
  // The first in the list is always used as the default download path.
  return Future.wait([
    AndroidPathProvider.picturesPath,
    AndroidPathProvider.downloadsPath,
    AndroidPathProvider.dcimPath,
    AndroidPathProvider.moviesPath,
  ]).then(BuiltList.of).handleError(logErrorHandler);
}
