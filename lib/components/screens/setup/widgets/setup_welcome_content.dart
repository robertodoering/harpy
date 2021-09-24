import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

/// Builds the first page for the [SetupScreen].
class SetupWelcomeContent extends StatelessWidget {
  const SetupWelcomeContent({
    required this.onStart,
  });

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;
    final authCubit = context.watch<AuthenticationCubit>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: config.paddingValue * 2),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'welcome',
                  style: theme.textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
                defaultVerticalSpacer,
                defaultVerticalSpacer,
                FittedBox(
                  child: Text(
                    authCubit.state.user!.name,
                    style: theme.textTheme.headline2,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          defaultVerticalSpacer,
          Text(
            "let's take a moment to setup your experience",
            style: theme.textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          defaultVerticalSpacer,
          Expanded(
            child: HarpyButton.custom(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'start',
                    style: theme.textTheme.headline6!.copyWith(height: 1),
                    maxLines: 1,
                  ),
                  defaultSmallHorizontalSpacer,
                  const Icon(CupertinoIcons.chevron_right),
                ],
              ),
              onTap: onStart,
            ),
          ),
        ],
      ),
    );
  }
}
