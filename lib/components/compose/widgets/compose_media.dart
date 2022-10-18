import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class ComposeMedia extends ConsumerWidget {
  const ComposeMedia();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(composeProvider);
    final notifier = ref.watch(composeProvider.notifier);

    return Padding(
      padding: theme.spacing.edgeInsets,
      child: ClipRRect(
        borderRadius: theme.shape.borderRadius,
        child: Stack(
          children: [
            if (state.type == MediaType.image)
              _ComposeImages(media: state.media!)
            else if (state.type == MediaType.gif)
              _ComposeGif(media: state.media!.single)
            else if (state.type == MediaType.video)
              ComposeVideo(media: state.media!.single),
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: RbyButton.card(
                icon: const Icon(CupertinoIcons.xmark),
                onTap: notifier.clear,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComposeImages extends StatelessWidget {
  const _ComposeImages({
    required this.media,
  });

  final BuiltList<PlatformFile> media;

  @override
  Widget build(BuildContext context) {
    final child = TweetImagesLayout(
      children: [
        for (final image in media)
          Image.file(
            File(image.path ?? ''),
            fit: BoxFit.cover,
            width: double.infinity,
            height: media.length > 1 ? double.infinity : null,
          ),
      ],
    );

    return media.length > 1
        ? AspectRatio(aspectRatio: 16 / 9, child: child)
        : child;
  }
}

class _ComposeGif extends StatelessWidget {
  const _ComposeGif({
    required this.media,
  });

  final PlatformFile media;

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(media.path ?? ''),
      fit: BoxFit.cover,
      width: double.infinity,
    );
  }
}
