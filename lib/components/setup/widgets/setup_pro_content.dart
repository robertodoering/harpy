import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

/// Builds the last page for the setup screen.
///
/// Only shown for users of the free version.
class SetupProContent extends ConsumerWidget {
  const SetupProContent();

  void _openHarpyPro(UrlLauncher launcher) {
    launcher(
      'https://play.google.com/store/apps/details?id=com.robertodoering.harpy.pro',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final launcher = ref.watch(launcherProvider);

    return Padding(
      padding: theme.spacing.edgeInsets,
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
                      HorizontalSpacer.normal,
                      Expanded(
                        child: Text(
                          'harpy pro',
                          style: theme.textTheme.displayMedium?.copyWith(
                            color: theme.colorScheme.onBackground,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: theme.spacing.base * 3),
                Text(
                  'support harpy and gain access to exclusive features',
                  style: theme.textTheme.headlineSmall,
                ),
                SizedBox(height: theme.spacing.base * 2),
                const _FeatureRow(
                  icon: Icons.ad_units_outlined,
                  text: 'no ads',
                ),
                SizedBox(height: theme.spacing.base * 2),
                const _FeatureRow(
                  icon: Icons.palette_outlined,
                  text: 'fully customizable themes',
                ),
                SizedBox(height: theme.spacing.base * 2),
                const _FeatureRow(
                  icon: CupertinoIcons.home,
                  text: 'home screen customization',
                ),
                SizedBox(height: theme.spacing.base * 2),
                const _FeatureRow(
                  icon: CupertinoIcons.textformat,
                  text: 'font customization',
                ),
                SizedBox(height: theme.spacing.base * 2),
                const _FeatureRow(
                  icon: Icons.more_horiz,
                  text: 'and more coming in the future',
                ),
              ],
            ),
          ),
          Padding(
            padding: theme.spacing.edgeInsets,
            child: Center(
              child: Wrap(
                spacing: theme.spacing.base,
                runSpacing: theme.spacing.base,
                children: [
                  RbyButton.text(
                    label: const Text('harpy pro'),
                    icon: const FlareIcon.shiningStar(),
                    onTap: () => _openHarpyPro(launcher),
                  ),
                  RbyButton.elevated(
                    label: const Text('finish setup'),
                    onTap: () => finishSetup(ref),
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
        HorizontalSpacer.normal,
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.titleLarge,
          ),
        ),
      ],
    );
  }
}
