import 'package:json_annotation/json_annotation.dart';

part 'media_upload.g.dart';

@JsonSerializable()
class FinalizeUpload {
  FinalizeUpload();

  factory FinalizeUpload.fromJson(Map<String, dynamic> json) =>
      _$FinalizeUploadFromJson(json);

  @JsonKey(name: "media_id")
  int mediaId;
  @JsonKey(name: "media_id_string")
  String mediaIdString;
  @JsonKey(name: "expires_after_secs")
  int expiresAfterSecs;
  int size;
  @JsonKey(name: "processing_info")
  ProcessingInfo processingInfo;

  Map<String, dynamic> toJson() => _$FinalizeUploadToJson(this);
}

@JsonSerializable()
class UploadStatus {
  UploadStatus();

  factory UploadStatus.fromJson(Map<String, dynamic> json) =>
      _$UploadStatusFromJson(json);

  @JsonKey(name: "media_id")
  int mediaId;
  @JsonKey(name: "media_id_string")
  String mediaIdString;
  @JsonKey(name: "expires_after_secs")
  int expiresAfterSecs;
  @JsonKey(name: "processing_info")
  ProcessingInfo processingInfo;

  Map<String, dynamic> toJson() => _$UploadStatusToJson(this);
}

@JsonSerializable()
class ProcessingInfo {
  ProcessingInfo();

  factory ProcessingInfo.fromJson(Map<String, dynamic> json) =>
      _$ProcessingInfoFromJson(json);

  String state;
  @JsonKey(name: "progress_percent")
  int progressPercent;
  @JsonKey(name: "check_after_secs")
  int checkAfterSecs;

  bool get pending => state == "pending";
  bool get inProgress => state == "in_progress";
  bool get succeeded => state == "succeeded";
  bool get failed => state == "failed";

  Map<String, dynamic> toJson() => _$ProcessingInfoToJson(this);
}
