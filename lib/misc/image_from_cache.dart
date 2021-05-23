import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/painting.dart';
import 'package:logging/logging.dart';

final _log = Logger('imageFromCache');

/// Returns the image data as a [Uint8List] from the [imageCache] if it exists.
///
/// The [key] is the [ImageProvider] which is used to map the image data (e.g
/// a [NetworkImage]).
///
/// If the cached image has multiple frames (i.e. a gif), only the first
/// frame will be returned.
Future<Uint8List?> imageDataFromCache(Object key) async {
  try {
    if (imageCache!.containsKey(key)) {
      final imageStreamCompleter = imageCache!.putIfAbsent(
        key,
        // we don't want to load and cache the image so we just throw an
        // exception and return null
        () => throw Exception('image not in cache'),
      );

      if (imageStreamCompleter != null) {
        return await _imageStreamHandler(imageStreamCompleter);
      } else {
        return null;
      }
    } else {
      _log.fine('image not in cache $key');
      return null;
    }
  } catch (e) {
    _log.fine('error retrieving image $key');
    return null;
  }
}

Future<Uint8List?> _imageStreamHandler(
  ImageStreamCompleter imageStreamCompleter,
) {
  final completer = Completer<Uint8List?>();

  var listenedOnce = false;

  imageStreamCompleter.addListener(
    ImageStreamListener((image, _) async {
      if (listenedOnce) {
        return;
      }

      listenedOnce = true;

      _log.info('got cached image');

      final byteData = await image.image.toByteData();

      if (byteData != null) {
        completer.complete(
          byteData.buffer.asUint8List(
            byteData.offsetInBytes,
            byteData.lengthInBytes,
          ),
        );
      } else {
        _log.warning('cached image byte data is null');
        completer.complete();
      }
    }, onError: (e, st) {
      _log.severe('error loading cached image', e, st);
      completer.complete();
    }),
  );

  return completer.future;
}
