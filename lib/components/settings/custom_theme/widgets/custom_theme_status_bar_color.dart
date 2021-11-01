import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

class CustomThemeStatusBarColor extends StatelessWidget {
  const CustomThemeStatusBarColor();

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;
    final cubit = context.watch<CustomThemeCubit>();

    return Padding(
      padding: config.edgeInsetsSymmetric(horizontal: true),
      child: CustomThemeColor(
        color: cubit.harpyTheme.statusBarColor,
        allowTransparency: true,
        title: const Text('status bar'),
        subtitle: Text(
          colorValueToDisplayHex(cubit.harpyTheme.statusBarColor.value),
        ),
        onColorChanged: cubit.changeStatusBarColor,
      ),
    );
  }
}
