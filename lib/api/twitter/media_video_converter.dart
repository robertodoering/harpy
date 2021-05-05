import 'dart:io';

import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

class MediaVideoConverter {
  static final Logger _log = Logger('MediaVideoConverter');

  final FlutterFFmpeg _ffmpeg = FlutterFFmpeg();

  /// Uses [FlutterFFmpeg] to convert the [sourcePath] file to follow the
  /// Twitter media video specifications.
  ///
  /// The converted video will be saved in the temp directory.
  ///
  /// Returns `null` if the conversion failed.
  ///
  /// See https://developer.twitter.com/en/docs/twitter-api/v1/media/upload-media/uploading-media/media-best-practices.
  Future<File?> convertVideo(String? sourcePath, String? extension) async {
    final Directory tempDir = await getTemporaryDirectory();
    final String outputPath = '${tempDir.path}/media_video.$extension';

    _log.fine(
        'converting video from: $sourcePath to destinationPath: $outputPath');

    // todo: also limit length of video

    final int result = await _ffmpeg.execute(
      // override existing output
      '-y '
      // set source path
      '-i $sourcePath '
      // set video codec to h264
      '-c:v h264 '
      // set audio codec to aac
      '-c:a aac '
      // set audio channel to stable
      '-ac 2 '
      // set framerate
      '-r 30 '
      // scale filter to limit the video size to 1280x720 (landscape) and
      // 720x1280 (portrait).
      r'-filter:v "scale=if(lt(dar\,1)\,min(iw*1280/ih\,720)\,min(iw*720/ih\,1280)):if(lt(dar\,1)\,min(1280\,ih*720/iw)\,min(720\,ih*1280/iw))" '
      '$outputPath',
    );

    _log.fine('conversion done with result code: $result');

    if (result == 0) {
      return File(outputPath);
    } else {
      return null;
    }
  }
}
