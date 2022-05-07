import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class HomeTabReorderCard extends ConsumerWidget {
  const HomeTabReorderCard({
    required this.index,
    required Key key,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final display = ref.watch(displayPreferencesProvider);
    final configuration = ref.watch(homeTabConfigurationProvider);
    final notifier = ref.watch(homeTabConfigurationProvider.notifier);
    final entry = configuration.entries[index];

    return AnimatedOpacity(
      duration: kShortAnimationDuration,
      opacity: entry.visible ? 1 : .6,
      child: Card(
        margin: EdgeInsets.only(bottom: display.smallPaddingValue),
        child: Row(
          children: [
            _HomeTabIcon(index: index, entry: entry),
            Flexible(
              child: _HomeTabNameTextField(
                entry: entry,
                onChanged: (value) => notifier.changeName(index, value),
              ),
            ),
            if (entry.removable)
              HarpyButton.icon(
                icon: Icon(
                  CupertinoIcons.xmark,
                  color: theme.colorScheme.primary,
                ),
                onTap: () {
                  HapticFeedback.lightImpact();
                  notifier.remove(index);
                },
              )
            else
              _HomeTabVisibility(index: index),
            ReorderableDragStartListener(
              index: index,
              child: Container(
                padding: display.edgeInsets.copyWith(left: 0),
                color: Colors.transparent,
                child: const Icon(CupertinoIcons.bars),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTabIcon extends ConsumerWidget {
  const _HomeTabIcon({
    required this.index,
    required this.entry,
  });

  final int index;
  final HomeTabEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notifier = ref.watch(homeTabConfigurationProvider.notifier);

    return HarpyButton.icon(
      icon: HomeTabEntryIcon(
        entry.icon,
        color: theme.colorScheme.primary,
      ),
      onTap: () async => showDialog<String>(
        context: context,
        builder: (_) => HomeTabIconDialog(entry: entry),
      ).then((value) {
        if (value != null) notifier.changeIcon(index, value);
      }),
    );
  }
}

class _HomeTabVisibility extends ConsumerWidget {
  const _HomeTabVisibility({
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final configuration = ref.watch(homeTabConfigurationProvider);
    final notifier = ref.watch(homeTabConfigurationProvider.notifier);
    final entry = configuration.entries[index];

    return HarpyButton.icon(
      icon: Icon(
        entry.visible ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
        color: theme.colorScheme.primary,
      ),
      onTap: () {
        HapticFeedback.lightImpact();
        notifier.toggleVisible(index);
      },
    );
  }
}

class _HomeTabNameTextField extends StatefulWidget {
  const _HomeTabNameTextField({
    required this.entry,
    required this.onChanged,
  });

  final HomeTabEntry entry;
  final ValueChanged<String> onChanged;

  @override
  _HomeTabNameTextFieldState createState() => _HomeTabNameTextFieldState();
}

class _HomeTabNameTextFieldState extends State<_HomeTabNameTextField> {
  late final _controller = TextEditingController(text: widget.entry.name);

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: _controller,
      scrollPadding: EdgeInsets.zero,
      enabled: isPro,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 4),
        isDense: true,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.dividerColor),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.dividerColor),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.dividerColor),
        ),
      ),
      style: theme.textTheme.subtitle1,
      onChanged: widget.onChanged,
    );
  }
}
