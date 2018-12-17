import 'dart:io';

import 'package:harpy/api/twitter/data/twitter_media.dart';
import 'package:harpy/api/twitter/services/media/media_service_impl.dart';
import 'package:harpy/core/process/process.dart';
import 'package:harpy/core/process/process_step.dart';
import 'package:logging/logging.dart';

class MediaUploadProcess extends HarpyProcess {
  @override
  List<ProcessStep> initSteps() {
    return [
      InitMediaUpload(),
      AppendMedia(),
      FinalizeMediaUpload(),
    ];
  }
}

class InitMediaUpload extends ProcessStep {
  @override
  Future performStep(data, prevResult) async {
    File media = data["media"];

    List<int> fileContentAsByte = media.readAsBytesSync();

    int totalBytes = fileContentAsByte.length;
    String mediaType = _getMediaTypeFromFile(media);

    Logger("InitMediaUpload").fine(
        "Init media upload. Total Bytes $totalBytes | mediaType $mediaType");

    data.putIfAbsent("totalBytes", () => totalBytes);
    data.putIfAbsent("mediaType", () => mediaType);
    data.putIfAbsent("data", () => fileContentAsByte);

    String twitterMediaId = await MediaServiceImpl()
        .initMediaUpload(totalBytes: totalBytes, mediaType: mediaType);

    Logger("InitMediaUpload").fine("Init media upload request done");

    print(twitterMediaId);
    data.putIfAbsent("twitter_media_id", () => twitterMediaId);

    return {"twitter_media": twitterMediaId};
  }

  String _getMediaTypeFromFile(File file) {
    String filePath = file.path;
    Logger("InitMediaUpload").fine("Get mediaType of $filePath");
    if (filePath.endsWith(".png")) {
      return "image/png";
    }
    if (filePath.endsWith(".jpeg") || filePath.endsWith(".jpg")) {
      return "image/jpeg";
    }

    return "";
  }
}

class AppendMedia extends ProcessStep {
  int _maxChunkSizeInBytes = 500000;

  @override
  Future performStep(data, prevResult) async {
    String twitterMediaId = data["twitter_media_id"];
    List<int> fileContent = data["data"];

    Logger("AppendMedia").fine("Append media for mediaId $twitterMediaId");

    List<List<int>> fileChunks = [];
    // e.g. 750kb => 750000bytes

    if (fileContent.length <= _maxChunkSizeInBytes) {
      Logger("AppendMedia").fine("Is only one chunk to upload");
      fileChunks.add(fileContent);
    } else {
      //todo
    }

    for (int i = 0; i < fileChunks.length; i++) {
      Logger("AppendMedia").fine("Append media request $i");
      await MediaServiceImpl().appendMedia(
        twitterMediaId: twitterMediaId,
        chunkIndex: i,
        chunkData: fileChunks[i],
      );
    }

    Logger("AppendMedia").fine("Append media done");
    return data;
  }
}

class FinalizeMediaUpload extends ProcessStep {
  @override
  Future performStep(data, prevResult) async {
    Logger("FinalizeMediaUpload").fine("finalizing media upload");

    String twitterMediaId = data["twitter_media_id"];

    TwitterMedia twitterMedia =
        await MediaServiceImpl().finalizeMediaUpload(mediaId: twitterMediaId);

    Logger("FinalizeMediaUpload")
        .fine("Media upload for $twitterMediaId done!");

    return {"completed_media": twitterMedia};
  }
}
