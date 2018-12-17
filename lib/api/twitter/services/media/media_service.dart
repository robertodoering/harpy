import 'dart:io';

import 'package:harpy/api/twitter/data/twitter_media.dart';
import 'package:meta/meta.dart';

abstract class MediaService {
  Future<TwitterMedia> upload({
    @required File media,
    bool sendAsBase64 = true,
    List<String> owners,
  });
}
