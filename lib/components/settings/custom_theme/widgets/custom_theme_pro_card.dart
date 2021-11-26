import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class CustomThemeProCard extends StatelessWidget {
  const CustomThemeProCard();

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return Padding(
      padding: config.edgeInsetsSymmetric(horizontal: true),
      child: const HarpyProCard(
        children: [
          Text(
            'theme customization is only available in the pro '
            'version of harpy',
          ),
        ],
      ),
    );
  }
}
