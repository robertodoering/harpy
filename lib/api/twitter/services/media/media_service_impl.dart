import 'dart:convert';
import 'dart:io';

import 'package:harpy/api/twitter/data/twitter_media.dart';
import 'package:harpy/api/twitter/services/media/media_service.dart';
import 'package:harpy/api/twitter/services/media/upload_process.dart';
import 'package:harpy/api/twitter/services/twitter_service.dart';
import 'package:harpy/core/json/json_mapper.dart';
import 'package:harpy/core/utils/file_utils.dart';
import 'package:harpy/core/utils/string_utils.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

class MediaServiceImpl extends TwitterService
    with JsonMapper<TwitterMedia>
    implements MediaService {
  Logger log = Logger("MediaServiceImpl");

  Future<TwitterMedia> uploadProcess({
    @required File media,
    bool sendAsBase64 = true,
    List<String> owners,
  }) async {
    var result = await MediaUploadProcess().start({
      "media": media,
      "sendAsBase64": sendAsBase64,
      "owners": owners,
    });

    return result["completed_media"];
  }

  @override
  Future<TwitterMedia> upload({
    @required File media,
    bool sendAsBase64 = true,
    List<String> owners,
  }) async {
    Map<String, dynamic> body = {};

    if (sendAsBase64) {
      body.putIfAbsent("media_data", () => convertFileToBase64(media: media));
    } else {
      body.putIfAbsent("media", () => media.readAsBytesSync());
    }

    if (owners != null) {
      body.putIfAbsent(
          "additional_owners", () => explodeListToSeparatedString(owners));
    }

    log.fine("Upload ${media.uri.toString()} to twitter");

    var response = await client.post(
      "https://upload.twitter.com/1.1/media/upload.json",
      body: body,
      headers: {"media_type": "multipart/form-data"},
    );

    if (response.statusCode == 200) {
      log.fine("Upload success");
      return map((map) => TwitterMedia.fromJson(map), response.body);
    } else {
      log.shout("Upload failed! Status Code ${response.statusCode}");
      return Future.error(response.body);
    }
  }

  Future<String> initMediaUpload({
    @required int totalBytes,
    @required String mediaType,
    List<String> additionalOwners,
  }) async {
    String totalBytesString = totalBytes.toString();
    var response = await client
        .post("https://upload.twitter.com/1.1/media/upload.json", body: {
      "command": "INIT",
      "total_bytes": totalBytesString,
      "media_type": mediaType,
//      "additional_owners": explodeListToSeparatedString(additionalOwners),
    });

    if (response.statusCode == 200 || response.statusCode == 202) {
      log.fine("Init success");
      print(response.body);
      return jsonDecode(response.body)["media_id_string"];
    } else {
      log.shout("Init failed! Status Code ${response.statusCode}");
      return Future.error(response.body);
    }
  }

  Future<void> appendMedia({
    @required String twitterMediaId,
    @required int chunkIndex,
    @required List<int> chunkData,
  }) async {
    log.fine(
        "Prepare request to append media for mediaId $twitterMediaId | chunk $chunkIndex | chunk size ${chunkData.length}");

//    String chunkDataString = "";
//    chunkData.forEach((byte) {
//      chunkDataString += byte.toString();
//    });

    print("chunk data length: ${chunkData.length}");

    var response = await client.multipartRequest(
      "https://upload.twitter.com/1.1/media/upload.json",
      headers: {
        "content_type": "multipart/form-data",
      },
      params: {
        "command": "APPEND",
        "media_id": twitterMediaId,
        "segment_index": chunkIndex.toString(),
      },
      fileBytes: chunkData,
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      log.fine("Append success");
    } else {
      log.shout("Append failed! Status Code ${response.statusCode}");
      return Future.error(response.body);
    }
  }

  Future<TwitterMedia> finalizeMediaUpload({@required String mediaId}) async {
    log.fine("prepare finalize media upload request");

    var response = await client.post(
      "https://upload.twitter.com/1.1/media/upload.json",
      body: {
        "command": "FINALIZE",
        "media_id": mediaId,
      },
    );

    if (response.statusCode == 201) {
      log.fine("Finalize success");
      return map((map) => TwitterMedia.fromJson(map), response.body);
    } else {
      log.shout("Finalize failed! Status Code ${response.statusCode}");
      return Future.error(response.body);
    }
  }
}
