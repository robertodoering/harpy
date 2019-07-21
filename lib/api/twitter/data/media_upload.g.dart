// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_upload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinalizeUpload _$FinalizeUploadFromJson(Map<String, dynamic> json) {
  return FinalizeUpload()
    ..mediaId = json['media_id'] as int
    ..mediaIdString = json['media_id_string'] as String
    ..expiresAfterSecs = json['expires_after_secs'] as int
    ..size = json['size'] as int
    ..processingInfo = json['processing_info'] == null
        ? null
        : ProcessingInfo.fromJson(
            json['processing_info'] as Map<String, dynamic>);
}

Map<String, dynamic> _$FinalizeUploadToJson(FinalizeUpload instance) =>
    <String, dynamic>{
      'media_id': instance.mediaId,
      'media_id_string': instance.mediaIdString,
      'expires_after_secs': instance.expiresAfterSecs,
      'size': instance.size,
      'processing_info': instance.processingInfo
    };

UploadStatus _$UploadStatusFromJson(Map<String, dynamic> json) {
  return UploadStatus()
    ..mediaId = json['media_id'] as int
    ..mediaIdString = json['media_id_string'] as String
    ..expiresAfterSecs = json['expires_after_secs'] as int
    ..processingInfo = json['processing_info'] == null
        ? null
        : ProcessingInfo.fromJson(
            json['processing_info'] as Map<String, dynamic>);
}

Map<String, dynamic> _$UploadStatusToJson(UploadStatus instance) =>
    <String, dynamic>{
      'media_id': instance.mediaId,
      'media_id_string': instance.mediaIdString,
      'expires_after_secs': instance.expiresAfterSecs,
      'processing_info': instance.processingInfo
    };

ProcessingInfo _$ProcessingInfoFromJson(Map<String, dynamic> json) {
  return ProcessingInfo()
    ..state = json['state'] as String
    ..progressPercent = json['progress_percent'] as int
    ..checkAfterSecs = json['check_after_secs'] as int;
}

Map<String, dynamic> _$ProcessingInfoToJson(ProcessingInfo instance) =>
    <String, dynamic>{
      'state': instance.state,
      'progress_percent': instance.progressPercent,
      'check_after_secs': instance.checkAfterSecs
    };
