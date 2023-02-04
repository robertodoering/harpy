import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

/// Shown when the navigator was unable to navigate to a page.
///
/// E.g. when parsing the route arguments throw an exception.
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
                  style: theme.textTheme.titleSmall,
                ),
                VerticalSpacer.normal,
                RbyButton.text(
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
