import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

class CustomApiPage extends StatelessWidget {
  const CustomApiPage();

  static const name = 'custom_api';
  static const path = 'custom_api';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return HarpyScaffold(
      child: CustomScrollView(
        slivers: [
          const HarpySliverAppBar(title: Text('custom api key')),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              vertical: theme.spacing.base,
              horizontal: theme.spacing.base * 2,
            ),
            sliver: const SliverFillRemaining(
              hasScrollBody: false,
              child: _Content(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final launcher = ref.watch(launcherProvider);
    final customApiPreferences = ref.watch(customApiPreferencesProvider);
    final customApiPreferencesNotifier = ref.watch(
      customApiPreferencesProvider.notifier,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: RbyButton.text(
            icon: const Icon(CupertinoIcons.info),
            label: const Text('setup guide'),
            onTap: () => launcher(
              'https://github.com/robertodoering/harpy/wiki/Twitter-api-key-setup',
            ),
          ),
        ),
        if (customApiPreferences.hasCustomApiKeyAndSecret) const _Table(),
        VerticalSpacer.normal,
        RbyDialogActionBar(
          actions: [
            RbyButton.text(
              label: const Text('remove'),
              onTap: customApiPreferences.hasCustomApiKeyAndSecret
                  ? () {
                      customApiPreferencesNotifier.setCustomCredentials(
                        key: '',
                        secret: '',
                      );
                    }
                  : null,
            ),
            RbyButton.elevated(
              label: customApiPreferences.hasCustomApiKeyAndSecret
                  ? const Text('change')
                  : const Text('set'),
              onTap: () => showDialog<void>(
                context: context,
                builder: (_) => const _FormDialog(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Table extends ConsumerWidget {
  const _Table();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final customApiPreferences = ref.watch(customApiPreferencesProvider);

    return Column(
      children: [
        VerticalSpacer.normal,
        Column(
          children: [
            Row(
              children: [
                Text(
                  'key',
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                HorizontalSpacer.small,
                Flexible(child: Text(customApiPreferences.customKey)),
              ],
            ),
            Row(
              children: [
                Text(
                  'secret',
                  style: theme.textTheme.bodyLarge!.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                HorizontalSpacer.small,
                Flexible(child: Text(customApiPreferences.customSecret)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _FormDialog extends ConsumerStatefulWidget {
  const _FormDialog();

  @override
  ConsumerState<_FormDialog> createState() => _FormDialogState();
}

class _FormDialogState extends ConsumerState<_FormDialog> {
  late final TextEditingController _keyController;
  late final TextEditingController _secretController;

  @override
  void initState() {
    super.initState();

    final customApiPreferences = ref.read(customApiPreferencesProvider);

    _keyController = TextEditingController(
      text: customApiPreferences.customKey,
    )..addListener(() => setState(() {}));

    _secretController = TextEditingController(
      text: customApiPreferences.customSecret,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();

    _keyController.dispose();
    _secretController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customApiPreferencesNotifier = ref.watch(
      customApiPreferencesProvider.notifier,
    );

    return RbyDialog(
      content: Column(
        children: [
          TextField(
            controller: _keyController,
            decoration: const InputDecoration(
              label: Text('key'),
            ),
          ),
          VerticalSpacer.normal,
          TextField(
            controller: _secretController,
            decoration: const InputDecoration(
              label: Text('secret'),
            ),
          ),
        ],
      ),
      actions: [
        RbyButton.text(
          label: const Text('cancel'),
          onTap: Navigator.of(context).pop,
        ),
        RbyButton.elevated(
          label: const Text('apply'),
          onTap: _keyController.text.trim().isNotEmpty &&
                  _secretController.text.trim().isNotEmpty
              ? () {
                  customApiPreferencesNotifier.setCustomCredentials(
                    key: _keyController.text.trim(),
                    secret: _secretController.text.trim(),
                  );
                  Navigator.of(context).pop();
                }
              : null,
        ),
      ],
    );
  }
}
