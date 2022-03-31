import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class HomeMediaTimeline extends ConsumerWidget {
  const HomeMediaTimeline({
    required this.scrollPosition,
  });

  final int scrollPosition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MediaTimeline(
      provider: homeTimelineProvider,
      beginSlivers: const [HomeTopSliverPadding()],
      endSlivers: const [HomeBottomSliverPadding()],
      scrollPosition: scrollPosition,
    );
  }
}
