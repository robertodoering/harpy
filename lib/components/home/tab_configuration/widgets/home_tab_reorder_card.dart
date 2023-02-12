import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

class HomeTabReorderCard extends ConsumerWidget {
  const HomeTabReorderCard({
    required this.index,
    required Key key,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final configuration = ref.watch(homeTabConfigurationProvider);
    final notifier = ref.watch(homeTabConfigurationProvider.notifier);
    final entry = configuration.entries[index];

    return AnimatedOpacity(
      duration: theme.animation.short,
      opacity: entry.visible ? 1 : .6,
      child: Card(
        margin: EdgeInsetsDirectional.only(bottom: theme.spacing.small),
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
              RbyButton.transparent(
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
            HarpyReorderableDragStartListener(
              index: index,
              child: Container(
                padding: theme.spacing.edgeInsets.copyWith(start: 0),
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

    return RbyButton.transparent(
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

    return RbyButton.transparent(
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
  void didUpdateWidget(covariant _HomeTabNameTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_controller.text != widget.entry.name) {
      _controller.text = widget.entry.name;
    }
  }

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
      style: theme.textTheme.titleMedium,
      onChanged: widget.onChanged,
    );
  }
}
