import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class CustomThemeProCard extends StatelessWidget {
  const CustomThemeProCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    return Padding(
      padding: config.edgeInsetsSymmetric(horizontal: true),
      child: HarpyProCard(
        children: [
          const Text(
            'theme customization is only available in the pro '
            'version of harpy',
          ),
          Text(
            '(coming soon)',
            style: theme.textTheme.subtitle2!.copyWith(
              color: Colors.white.withOpacity(.6),
            ),
          ),
        ],
      ),
    );
  }
}
