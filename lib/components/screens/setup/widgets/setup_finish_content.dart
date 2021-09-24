import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

/// Builds the third page for the [SetupScreen].
class SetupFinishContent extends StatelessWidget {
  const SetupFinishContent();

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

    return Padding(
      padding: config.edgeInsets,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: const [
                _CrashReports(),
                defaultVerticalSpacer,
                defaultVerticalSpacer,
                _FollowHarpy(),
              ],
            ),
          ),
          if (Harpy.isPro)
            Padding(
              padding: config.edgeInsets,
              child: Center(
                child: HarpyButton.flat(
                  text: const Text('finish setup'),
                  onTap: () => app<HarpyNavigator>().pushReplacementNamed(
                    HomeScreen.route,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CrashReports extends StatefulWidget {
  const _CrashReports();

  @override
  _CrashReportsState createState() => _CrashReportsState();
}

class _CrashReportsState extends State<_CrashReports> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final generalPreferences = app<GeneralPreferences>();

    return Card(
      child: HarpySwitchTile(
        value: generalPreferences.crashReports,
        multilineTitle: true,
        borderRadius: kDefaultBorderRadius,
        title: Text(
          'send automatic crash reports',
          style: theme.textTheme.headline5,
          maxLines: 2,
        ),
        subtitle: Text(
          'anonymously report errors to improve harpy',
          style: theme.textTheme.subtitle2,
        ),
        onChanged: (value) {
          HapticFeedback.lightImpact();
          setState(() => generalPreferences.crashReports = value);
        },
      ),
    );
  }
}

class _FollowHarpy extends StatelessWidget {
  const _FollowHarpy();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final userProfileBloc = context.watch<UserProfileBloc>();
    final following = userProfileBloc.user?.following ?? false;

    return Card(
      child: HarpySwitchTile(
        value: following,
        borderRadius: kDefaultBorderRadius,
        title: Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'follow '),
              TextSpan(
                text: '@harpy_app',
                style: theme.textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          style: theme.textTheme.headline5,
        ),
        onChanged: (value) {
          HapticFeedback.lightImpact();
          following
              ? userProfileBloc.add(const UnfollowUserEvent())
              : userProfileBloc.add(const FollowUserEvent());
        },
      ),
    );
  }
}
