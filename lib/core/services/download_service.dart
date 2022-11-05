import 'dart:async';

import 'package:download_manager/download_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rby/rby.dart';

final downloadServiceProvider = Provider(
  (ref) => const DownloadService(),
  name: 'DownloadServiceProvider',
);

class DownloadService with LoggerMixin {
  const DownloadService();

  Future<void> download({
    required String url,
    required String name,
    required String path,
  }) async {
    await DownloadManager.enqueue(
      url: url,
      path: path,
      name: name,
    ).handleError(logErrorHandler);
  }
}
