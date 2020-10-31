import 'dart:io';

import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:harpy/core/message_service.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadService {
  MessageService get messageService => app<MessageService>();

  Future<void> initialize() async {
    await FlutterDownloader.initialize();
  }

  Future<void> download({
    @required String url,
    String name,
  }) async {
    final Directory directory = await _requestDownloadDirectory();

    if (directory != null) {
      try {
        await FlutterDownloader.enqueue(
          url: url,
          savedDir: directory.path,
          fileName: name,
        );

        messageService.show('Download started');
      } catch (e) {
        messageService.show('Download failed');
      }
    }
  }

  Future<Directory> _requestDownloadDirectory() async {
    final MessageService messageService = app<MessageService>();

    final PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      return DownloadsPathProvider.downloadsDirectory;
    } else {
      messageService.show('Download started');

      return null;
    }
  }
}
