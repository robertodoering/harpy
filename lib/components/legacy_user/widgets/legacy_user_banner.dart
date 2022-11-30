import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

class LegacyUserBanner extends StatefulWidget {
  const LegacyUserBanner({
    required this.url,
  });

  final String url;

  @override
  State<LegacyUserBanner> createState() => _LegacyUserBannerState();
}

class _LegacyUserBannerState extends State<LegacyUserBanner> {
  ScrollController? _controller;

  bool _enableTap = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _controller ??= PrimaryScrollController.of(context)
      ?..addListener(_listener);
  }

  @override
  void dispose() {
    _controller?.removeListener(_listener);

    super.dispose();
  }

  void _listener() {
    if (!mounted) return;

    if (!_enableTap && _controller!.positions.first.extentAfter > 50) {
      setState(() => _enableTap = true);
    } else if (_enableTap && _controller!.positions.first.extentAfter <= 50) {
      setState(() => _enableTap = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _enableTap
          ? () => _showFullscreenBanner(context, url: widget.url)
          : null,
      child: Hero(
        tag: widget.url,
        child: HarpyImage(
          imageUrl: widget.url,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

void _showFullscreenBanner(
  BuildContext context, {
  required String url,
}) {
  Navigator.of(context).push<void>(
    HeroDialogRoute(
      builder: (_) => HarpyDismissible(
        onDismissed: Navigator.of(context).pop,
        child: HarpyPhotoGallery(
          itemCount: 1,
          builder: (_, __) => Hero(
            tag: url,
            child: HarpyImage(
              imageUrl: url,
            ),
          ),
        ),
      ),
    ),
  );
}
