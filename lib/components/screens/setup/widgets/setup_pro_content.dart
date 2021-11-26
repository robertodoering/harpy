import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

/// Builds the last page for the setup screen.
///
/// Only shown for users of the free version.
class SetupProContent extends StatelessWidget {
  const SetupProContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    return Padding(
      padding: config.edgeInsets,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Row(
                  children: [
                    const FlareIcon.shiningStar(size: 96),
                    horizontalSpacer,
                    Expanded(
                      child: Text(
                        'harpy pro',
                        style: theme.textTheme.headline2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: config.paddingValue * 3),
                Text(
                  'support harpy and gain access to exclusive features',
                  style: theme.textTheme.headline5,
                ),
                SizedBox(height: config.paddingValue * 2),
                const _FeatureRow(
                  icon: Icons.ad_units_outlined,
                  text: 'no ads',
                ),
                SizedBox(height: config.paddingValue * 2),
                const _FeatureRow(
                  icon: Icons.palette_outlined,
                  text: 'fully customizable themes',
                ),
                SizedBox(height: config.paddingValue * 2),
                const _FeatureRow(
                  icon: CupertinoIcons.home,
                  text: 'home screen customization',
                ),
                SizedBox(height: config.paddingValue * 2),
                const _FeatureRow(
                  icon: CupertinoIcons.textformat,
                  text: 'font customization',
                ),
                SizedBox(height: config.paddingValue * 2),
                const _FeatureRow(
                  icon: Icons.more_horiz,
                  text: 'and more coming in the future',
                ),
                SizedBox(height: config.paddingValue * 3),
                UnconstrainedBox(
                  child: HarpyButton.raised(
                    backgroundColor: theme.colorScheme.primary,
                    text: const Text(
                      'harpy pro',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () => launchUrl(
                      'https://play.google.com/store/apps/details?id=com.robertodoering.harpy.pro',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: config.edgeInsets,
            child: Center(
              child: HarpyButton.raised(
                backgroundColor: theme.colorScheme.primary,
                text: const Text('finish setup'),
                onTap: finishSetup,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 26,
          color: theme.colorScheme.secondary,
        ),
        horizontalSpacer,
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.headline6,
          ),
        ),
      ],
    );
  }
}
