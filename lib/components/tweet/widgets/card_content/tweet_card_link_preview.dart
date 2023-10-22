import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';
import 'package:shimmer/shimmer.dart';

class TweetCardLinkPreview extends ConsumerWidget {
  const TweetCardLinkPreview({
    required this.tweet,
  });

  final LegacyTweetData tweet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final launcher = ref.watch(launcherProvider);
    final urlString = tweet.previewUrl.toString();

    return GestureDetector(
      onTap: () => launcher(urlString),
      onLongPress: () => defaultOnUrlLongPress(
        ref,
        UrlData(
          expandedUrl: urlString,
          displayUrl: urlString,
          url: urlString,
        ),
      ),
      child: AnyLinkPreview.builder(
        link: '${tweet.previewUrl}',
        placeholderWidget: const _LinkPreviewPlaceholder(),
        errorWidget: _LinkPreviewError(url: tweet.previewUrl!),
        itemBuilder: (_, metadata, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: theme.shape.borderRadius,
            border: Border.all(color: theme.dividerColor),
          ),
          height: 100,
          child: Row(
            children: [
              if (imageProvider != null)
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: theme.shape.radius,
                    topLeft: theme.shape.radius,
                  ),
                  child: HarpyImage.fromImageProvider(
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    imageProvider: imageProvider,
                  ),
                ),
              Expanded(
                child: _LinkPreviewText(metadata: metadata),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinkPreviewPlaceholder extends StatelessWidget {
  const _LinkPreviewPlaceholder();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      // empty on tap to prevent tap gestures on loading shimmer
      onTap: () {},
      child: Shimmer(
        gradient: LinearGradient(
          colors: [
            theme.cardTheme.color!.withOpacity(.3),
            theme.cardTheme.color!.withOpacity(.3),
            theme.colorScheme.secondary,
            theme.cardTheme.color!.withOpacity(.3),
            theme.cardTheme.color!.withOpacity(.3),
          ],
        ),
        child: Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: theme.shape.borderRadius,
          ),
        ),
      ),
    );
  }
}

class _LinkPreviewError extends StatelessWidget {
  const _LinkPreviewError({
    required this.url,
  });

  final Uri url;

  String get urlStr {
    final urlString = '$url';

    if (urlString.length > 40) {
      return '${urlString.substring(0, 40)}...';
    }

    return urlString;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: theme.shape.borderRadius,
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Container(
            padding: theme.spacing.edgeInsets,
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.only(
                topLeft: theme.shape.radius,
                bottomLeft: theme.shape.radius,
              ),
            ),
            child: FittedBox(
              child: Icon(
                CupertinoIcons.link,
                color: theme.iconTheme.color,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(theme.spacing.small),
              child: FittedBox(
                child: Text(
                  urlStr,
                  style: theme.textTheme.titleSmall,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkPreviewText extends StatelessWidget {
  const _LinkPreviewText({
    required this.metadata,
  });

  final Metadata metadata;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final title = metadata.title != 'null' ? metadata.title : null;
    final desc = metadata.desc != 'null' ? metadata.desc : null;

    return Padding(
      padding: EdgeInsets.all(theme.spacing.small),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title?.isNotEmpty ?? false) ...[
                  FittedBox(
                    child: Text(
                      limitLength(title!, 40),
                      maxLines: 2,
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                if (desc?.isNotEmpty ?? false)
                  Text(
                    desc!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(height: 1.15)
                        .apply(
                          fontSizeDelta: -4,
                          color: theme.colorScheme.onBackground.withOpacity(.9),
                        ),
                  ),
              ],
            ),
          ),
          Text(
            metadata.url ?? '',
            maxLines: 1,
            overflow: TextOverflow.visible,
            style: theme.textTheme.bodySmall?.apply(fontSizeDelta: -4),
          ),
        ],
      ),
    );
  }
}
