part of 'compose_bloc.dart';

class ComposeState extends Equatable {
  const ComposeState({
    this.media = const <PlatformFile>[],
    this.type,
  });

  final List<PlatformFile> media;
  final MediaType? type;

  bool get hasMedia => media.isNotEmpty;
  bool get hasImages => type == MediaType.image;
  bool get hasGif => type == MediaType.gif;
  bool get hasVideo => type == MediaType.video;

  @override
  List<Object?> get props => <Object?>[
        media,
        type,
      ];
}
