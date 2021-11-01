import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

class CustomThemeNavBarColor extends StatelessWidget {
  const CustomThemeNavBarColor();

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;
    final cubit = context.watch<CustomThemeCubit>();

    return Padding(
      padding: config.edgeInsetsSymmetric(horizontal: true),
      child: CustomThemeColor(
        color: cubit.harpyTheme.navBarColor,
        allowTransparency: true,
        title: const Text('navigation bar'),
        subtitle: Text(
          colorValueToDisplayHex(cubit.harpyTheme.navBarColor.value),
        ),
        onColorChanged: cubit.changeNavBarColor,
      ),
    );
  }
}
