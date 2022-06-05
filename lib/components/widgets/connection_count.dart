import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

typedef ConnectionCountBuilder = Widget Function(String count);

class ConnectionCount extends StatelessWidget {
  const ConnectionCount({
    required this.count,
    required this.builder,
  });

  final int count;
  final ConnectionCountBuilder builder;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();

    final compactFormat = intl.NumberFormat.compact(locale: locale);
    final formattedCount = compactFormat.format(count);

    final child = builder(formattedCount);

    return '$count' != formattedCount
        // only build tooltip when the number got shortened
        ? Tooltip(
            message: intl.NumberFormat.decimalPattern(locale).format(count),
            child: child,
          )
        : child;
  }
}
