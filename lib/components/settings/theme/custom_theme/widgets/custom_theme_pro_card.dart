import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class CustomThemeProCard extends ConsumerWidget {
  const CustomThemeProCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const HarpyProCard(
      children: [
        Text(
          'theme customization is only available in the pro '
          'version of harpy',
        ),
      ],
    );
  }
}
