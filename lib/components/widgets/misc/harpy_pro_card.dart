import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';

class HarpyProCard extends StatelessWidget {
  const HarpyProCard({
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final headline = theme.textTheme.headline6!.copyWith(
      fontWeight: FontWeight.normal,
      color: Colors.white,
      shadows: [
        const Shadow(
          color: Colors.black45,
          offset: Offset(2, 2),
          blurRadius: 4,
        ),
      ],
    );

    final textStyle = theme.textTheme.subtitle2!.copyWith(
      color: Colors.white,
      shadows: [
        const Shadow(
          color: Colors.black26,
          offset: Offset(2, 2),
          blurRadius: 4,
        ),
      ],
    );

    return Material(
      borderRadius: kBorderRadius,
      elevation: 4,
      color: Colors.transparent,
      // clip the container and the custom paint
      child: ClipRRect(
        borderRadius: kBorderRadius,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff8B00FD),
                Color(0xffBC0492),
                Color(0xffFD0A04),
              ],
            ),
          ),
          child: CustomPaint(
            painter: const _ProCardPainter(),
            // material for the ink well
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: kBorderRadius,
                onTap: () => launchUrl(
                  'https://play.google.com/store/apps/details?id=com.robertodoering.harpy.pro',
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: DefaultTextStyle(
                    style: textStyle,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FlareIcon.shiningStar(size: 32),
                            const SizedBox(width: 8),
                            Text('harpy pro', style: headline),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...children,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Paints two curved paths in the opposite gradient that is used with the
/// [HarpyProCard] to make it more interesting.
class _ProCardPainter extends CustomPainter {
  const _ProCardPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset.zero,
        Offset(size.width, size.height),
        const [
          Color(0x77FD0A04),
          Color(0x77BC0492),
          Color(0x778B00FD),
        ],
        [0, .5, 1],
      );

    final width1 = size.width * 1 / 3;
    final height1 = size.height * 1 / 3;

    final path1 = Path()
      ..moveTo(0, height1)
      ..quadraticBezierTo(
        width1 * 1 / 6, height1 / 2,
        //
        width1 / 2, height1 / 2,
      )
      ..quadraticBezierTo(
        width1 * 7 / 8, height1 / 2,
        //
        width1, 0,
      )
      ..lineTo(0, 0);

    final path2 = Path()
      ..moveTo(size.width * 1 / 2, size.height)
      ..quadraticBezierTo(
        size.width * 1 / 2, size.height * 2 / 3,
        //
        size.width * 1 / 2 + size.width / 4, size.height * 2 / 3,
      )
      ..quadraticBezierTo(
        size.width, size.height * 2 / 3,
        //
        size.width, size.height * 1 / 3,
      )
      ..lineTo(size.width, size.height);

    canvas
      ..drawPath(path1, overlayPaint)
      ..drawPath(path2, overlayPaint)
      ..drawPath(
        path1,
        overlayPaint..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      )
      ..drawPath(
        path2,
        overlayPaint..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
