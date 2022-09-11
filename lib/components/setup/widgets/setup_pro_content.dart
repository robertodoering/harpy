import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/rby/rby.dart';

/// Builds the last page for the setup screen.
///
/// Only shown for users of the free version.
class SetupProContent extends ConsumerWidget {
  const SetupProContent();

  void _openHarpyPro(Launcher launcher) {
    launcher.safeLaunchUrl(
      'https://play.google.com/store/apps/details?id=com.robertodoering.harpy.pro',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);
    final display = ref.watch(displayPreferencesProvider);
    final launcher = ref.watch(launcherProvider);

    return Padding(
      padding: display.edgeInsets,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => _openHarpyPro(launcher),
                  child: Row(
                    children: [
                      const FlareIcon.shiningStar(iconSize: 72),
                      horizontalSpacer,
                      Expanded(
                        child: Text(
                          'harpy pro',
                          style: theme.textTheme.headline2?.copyWith(
                            color: harpyTheme.colors.onBackground,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: display.paddingValue * 3),
                Text(
                  'support harpy and gain access to exclusive features',
                  style: theme.textTheme.headline5,
                ),
                SizedBox(height: display.paddingValue * 2),
                const _FeatureRow(
                  icon: Icons.ad_units_outlined,
                  text: 'no ads',
                ),
                SizedBox(height: display.paddingValue * 2),
                const _FeatureRow(
                  icon: Icons.palette_outlined,
                  text: 'fully customizable themes',
                ),
                SizedBox(height: display.paddingValue * 2),
                const _FeatureRow(
                  icon: CupertinoIcons.home,
                  text: 'home screen customization',
                ),
                SizedBox(height: display.paddingValue * 2),
                const _FeatureRow(
                  icon: CupertinoIcons.textformat,
                  text: 'font customization',
                ),
                SizedBox(height: display.paddingValue * 2),
                const _FeatureRow(
                  icon: Icons.more_horiz,
                  text: 'and more coming in the future',
                ),
              ],
            ),
          ),
          Padding(
            padding: display.edgeInsets,
            child: Center(
              child: Wrap(
                spacing: display.paddingValue,
                runSpacing: display.paddingValue,
                children: [
                  HarpyButton.text(
                    label: const Text('harpy pro'),
                    icon: const FlareIcon.shiningStar(),
                    onTap: () => _openHarpyPro(launcher),
                  ),
                  HarpyButton.elevated(
                    label: const Text('finish setup'),
                    onTap: () => finishSetup(ref.read),
                  ),
                ],
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
