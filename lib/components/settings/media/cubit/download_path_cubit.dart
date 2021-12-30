import 'dart:convert';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harpy/api/helper/network_error_handler.dart';
import 'package:harpy/api/twitter/media_type.dart';
import 'package:harpy/core/core.dart';

part 'download_path_cubit.freezed.dart';
part 'download_path_cubit.g.dart';

/// Handles customization of the download path for each media type.
class DownloadPathCubit extends Cubit<DownloadPathState> with HarpyLogger {
  DownloadPathCubit() : super(const DownloadPathState.loading()) {
    initialize();
  }

  Future<void> initialize() async {
    emit(const DownloadPathState.loading());

    final mediaPaths = await _mediaPaths();

    if (mediaPaths == null) {
      emit(const DownloadPathState.error());
      return;
    }

    final downloadPathData = app<MediaPreferences>().downloadPathData;

    if (downloadPathData.isEmpty) {
      // use default
      emit(
        DownloadPathState.data(
          mediaPaths: mediaPaths,
          entries: _defaultEntries(mediaPaths),
        ),
      );
    } else {
      try {
        final Map<String, dynamic> json = jsonDecode(downloadPathData);

        final data = DownloadPathData.fromJson(json);

        final entries = data.entries
            .where((entry) => mediaPaths.contains(entry.path))
            .toBuiltList();

        emit(DownloadPathState.data(mediaPaths: mediaPaths, entries: entries));
      } catch (e, st) {
        log.severe('error decoding downloda path data', e, st);

        // reset saved preferences and use default

        app<MediaPreferences>().downloadPathData = '';

        emit(
          DownloadPathState.data(
            mediaPaths: mediaPaths,
            entries: _defaultEntries(mediaPaths),
          ),
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
          app<MediaPreferences>().downloadPathData = jsonEncode(
            DownloadPathData(entries: entries).toJson(),
          );

          emit(
            currentState.copyWith(
              entries: entries.toBuiltList(),
            ),
          );
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
  ]).then(BuiltList.of).handleError(silentErrorHandler);
}
