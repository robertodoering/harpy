import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:harpy/components/components.dart';

/// Shown when the navigator was unable to navigate to a page.
///
/// E.g. when parsing the route's arguments throw an exception.
class ErrorPage extends StatelessWidget {
  const ErrorPage({
    this.error,
  });

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return HarpyScaffold(
      safeArea: true,
      child: CustomScrollView(
        slivers: [
          const HarpySliverAppBar(title: Text('error')),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'oops! something went wrong',
                  style: theme.textTheme.subtitle2,
                ),
                verticalSpacer,
                HarpyButton.text(
                  label: const Text('home'),
                  onTap: () => context.goNamed(HomePage.name),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
