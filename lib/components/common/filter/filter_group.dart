import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/implicit/animated_size.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';

class FilterGroup extends StatelessWidget {
  const FilterGroup({
    @required this.title,
    @required this.children,
    this.margin,
  });

  final String title;
  final EdgeInsets margin;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      margin: margin ?? DefaultEdgeInsets.symmetric(horizontal: true),
      child: CustomAnimatedSize(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: DefaultEdgeInsets.all(),
              child: Text(title, style: theme.textTheme.subtitle2),
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}
