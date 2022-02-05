import 'package:flutter/material.dart';
import 'package:harpy/legacy/components/components.dart';
import 'package:harpy/legacy/misc/misc.dart';
import 'package:provider/provider.dart';

class CustomThemeCardColor extends StatelessWidget {
  const CustomThemeCardColor();

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;
    final cubit = context.watch<CustomThemeCubit>();

    return Padding(
      padding: config.edgeInsetsSymmetric(horizontal: true),
      child: CustomThemeColor(
        color: cubit.harpyTheme.cardColor,
        allowTransparency: true,
        title: const Text('card'),
        subtitle: Text(
          colorValueToDisplayHex(cubit.harpyTheme.cardColor.value),
        ),
        onColorChanged: cubit.changeCardColor,
      ),
    );
  }
}
