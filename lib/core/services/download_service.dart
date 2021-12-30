import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/misc/misc.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

const _timeout = Duration(seconds: 30);

class DownloadService with HarpyLogger {
  const DownloadService();

  Future<void> download({
    required String url,
    required String name,
    required String path,
    VoidCallback? onStart,
    ValueChanged<String>? onSuccess,
    VoidCallback? onFailure,
  }) async {
    File? file;
    http.Response? response;

    try {
      // create directory in case it doesn't exist already
      final directory = Directory(path)..createSync(recursive: true);

      file = File('${directory.path}/$name');

      log.fine('downloading media');

      response = await http.get(Uri.parse(url)).timeout(_timeout);

      file.writeAsBytesSync(response.bodyBytes);

      log.fine('download successful');

      onSuccess?.call(path);
    } on FileSystemException catch (e, st) {
      if (e.osError?.message.contains('Operation not permitted') ?? false) {
        // ask the user to grant 'manage storage' permission
        if (file != null && response != null) {
          await _onFileSystemException(
            file: file,
            path: path,
            bytes: response.bodyBytes,
          );
        }
      } else {
        log.severe('unhandled FileSystemException', e, st);

        onFailure?.call();
      }
    } catch (e, st) {
      log.severe('error while trying to download file', e, st);

      onFailure?.call();
    }
  }

  Future<void> _onFileSystemException({
    required File file,
    required String path,
    required Uint8List bytes,
  }) async {
    // ask the user to grant 'manage storage' permission and try again if the
    // permissions are granted

    app<MessageService>().messageState.state.hideCurrentSnackBar();

    try {
      final grant = await showDialog<bool>(
        context: app<HarpyNavigator>().state.context,
        builder: (_) => ManageStoragePermissionDialog(path: path),
      );

      if (grant ?? false) {
        final status = await Permission.manageExternalStorage.request();

        if (status.isGranted) {
          file.writeAsBytesSync(bytes);

          app<MessageService>().show('media saved in\n$path');
        } else {
          app<MessageService>().show('storage permission not granted');
        }
      }
    } catch (e, st) {
      log.severe('error while writing file', e, st);

      app<MessageService>().show('saving media failed');
    }
  }
}

/// The current status of a download.
///
/// Used to display a status message in a snack bar.
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
