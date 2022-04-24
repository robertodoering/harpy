import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class HarpyMarkdown extends StatelessWidget {
  const HarpyMarkdown(this.data);

  final String data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Markdown(
      data: data,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
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
