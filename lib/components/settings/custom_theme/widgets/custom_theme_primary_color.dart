import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

class CustomThemePrimaryColor extends StatelessWidget {
  const CustomThemePrimaryColor();

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;
    final cubit = context.watch<CustomThemeCubit>();

    return Padding(
      padding: config.edgeInsetsSymmetric(horizontal: true),
      child: CustomThemeColor(
        color: cubit.harpyTheme.primaryColor,
        title: const Text('primary'),
        subtitle: Text(
          colorValueToDisplayHex(
            cubit.harpyTheme.primaryColor.value,
            displayOpacity: false,
          ),
        ),
        onColorChanged: cubit.changePrimaryColor,
      ),
    );
  }
}
