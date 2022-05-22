import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/core/core.dart';

class HarpyMarkdown extends ConsumerWidget {
  const HarpyMarkdown(this.data);

  final String data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Markdown(
      data: data,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      onTapLink: (_, href, __) => _onLinkTap(context, ref.read, href: href),
      styleSheet: MarkdownStyleSheet(
        code: theme.textTheme.bodyText2!.copyWith(
          backgroundColor: theme.colorScheme.onBackground.withOpacity(.07),
          fontFamily: 'monospace',
          fontSize: theme.textTheme.bodyText2!.fontSize! * 0.85,
        ),
      ),
    );
  }
}

void _onLinkTap(BuildContext context, Reader read, {required String? href}) {
  if (href == null) return;

  final router = read(routerProvider);

  if (router.location.startsWith('/home')) router.go(href);
}
