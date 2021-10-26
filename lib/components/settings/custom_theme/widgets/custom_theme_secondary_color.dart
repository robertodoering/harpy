import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

class CustomThemeSecondaryColor extends StatelessWidget {
  const CustomThemeSecondaryColor();

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;
    final cubit = context.watch<CustomThemeCubit>();

    return Padding(
      padding: config.edgeInsetsSymmetric(horizontal: true),
      child: CustomThemeColor(
        color: cubit.harpyTheme.secondaryColor,
        title: const Text('secondary'),
        subtitle: Text(
          colorValueToDisplayHex(
            cubit.harpyTheme.secondaryColor.value,
            displayOpacity: false,
          ),
        ),
        onColorChanged: cubit.changeSecondaryColor,
      ),
    );
  }
}
