import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:harpy/core/core.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class DownloadService with HarpyLogger {
  /// Downloads the file for the [url] into the downloads directory.
  ///
  /// If the file is an image, we try to get the data from the image cache
  /// first before downloading the image.
  Future<void> download({
    required String url,
    required String name,
    VoidCallback? onStart,
    VoidCallback? onSuccess,
    VoidCallback? onFailure,
  }) async {
    final path = await _requestDownloadDirectory();

    if (path != null) {
      try {
        onStart?.call();

        // create directory in case it doesn't exist already
        final directory = Directory(path);
        directory.createSync(recursive: true);

        final file = File('${directory.path}/$name');

        log.fine('downloading media');

        final response =
            await http.get(Uri.parse(url)).timeout(const Duration(seconds: 30));

        await compute<List<dynamic>, void>(_writeFile, <dynamic>[
          file,
          response.bodyBytes,
        ]);

        log.fine('download successful');

        onSuccess?.call();
      } catch (e, st) {
        log.severe('error while trying to download file', e, st);

        onFailure?.call();
      }
    }
  }

  Future<String?> _requestDownloadDirectory() async {
    final messageService = app<MessageService>();

    final status = await Permission.storage.request();

    if (status.isGranted) {
      return AndroidPathProvider.downloadsPath;
    } else {
      messageService.show('storage permission not granted');

      return null;
    }
  }
}

void _writeFile(List<dynamic> args) {
  final File file = args[0];
  final Uint8List bytes = args[1];

  file.writeAsBytesSync(bytes);
}

/// The current status of a download.
///
/// Used to display a status message in a snack bar.
@immutable
class DownloadStatus {
  const DownloadStatus({
    required this.message,
    required this.state,
  });

  final String message;
  final DownloadState state;
}

enum DownloadState {
  inProgress,
  successful,
  failed,
}
