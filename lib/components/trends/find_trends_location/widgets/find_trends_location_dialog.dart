import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

/// Allows to find a location for trends by using the location service to find
/// nearby locations or by entering custom coordinates for any arbitrary
/// location.
class FindTrendsLocationDialog extends ConsumerStatefulWidget {
  const FindTrendsLocationDialog();

  @override
  _FindLocationDialogState createState() => _FindLocationDialogState();
}

class _FindLocationDialogState extends ConsumerState<FindTrendsLocationDialog>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    final display = ref.watch(displayPreferencesProvider);
    final notifier = ref.watch(findTrendsLocationProvider.notifier);

    return HarpyDialog(
      title: const Text('find location'),
      contentPadding: display.edgeInsetsOnly(top: true),
      clipBehavior: Clip.antiAlias,
      content: SizedBox(
        height: 300,
        child: TabBarView(
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _FindMethodContent(
              onNearby: () {
                HapticFeedback.lightImpact();
                notifier.nearby();
                _controller.animateTo(2, duration: kShortAnimationDuration);
              },
              onCustom: () {
                _controller.animateTo(1, duration: kShortAnimationDuration);
              },
            ),
            FindCustomTrendsLocation(
              onSearch: (coords) {
                FocusScope.of(context).unfocus();
                HapticFeedback.lightImpact();
                notifier.search(
                  latitude: coords.item1,
                  longitude: coords.item2,
                );
                _controller.animateTo(2, duration: kShortAnimationDuration);
              },
            ),
            const FoundTrendsLocations(),
          ],
        ),
      ),
      actions: [
        AnimatedBuilder(
          animation: _controller,
          builder: (_, __) => _controller.index == 0
              ? HarpyButton.text(
                  label: const Text('cancel'),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).pop();
                  },
                )
              : HarpyButton.text(
                  label: const Text('back'),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _controller.animateTo(0, duration: kShortAnimationDuration);
                  },
                ),
        ),
      ],
    );
  }
}

class _FindMethodContent extends ConsumerWidget {
  const _FindMethodContent({
    required this.onNearby,
    required this.onCustom,
  });

  final VoidCallback onNearby;
  final VoidCallback onCustom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        HarpyListTile(
          leading: const Icon(CupertinoIcons.location),
          title: const Text('nearby locations'),
          subtitle: const Text('requires location service'),
          onTap: onNearby,
        ),
        HarpyListTile(
          leading: const Icon(CupertinoIcons.map_pin_ellipse),
          title: const Text('custom location'),
          subtitle: const Text('enter your longitude / latitude'),
          onTap: onCustom,
        ),
      ],
    );
  }
}
