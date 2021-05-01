import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class HarpyProCard extends StatelessWidget {
  const HarpyProCard({
    @required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final TextStyle headline = theme.textTheme.headline6.copyWith(
      fontWeight: FontWeight.normal,
      color: Colors.white,
      shadows: <Shadow>[
        const Shadow(
          color: Colors.black45,
          offset: Offset(2, 2),
          blurRadius: 4,
        ),
      ],
    );

    final TextStyle textStyle = theme.textTheme.subtitle2.copyWith(
      color: Colors.white,
      shadows: <Shadow>[
        const Shadow(
          color: Colors.black26,
          offset: Offset(2, 2),
          blurRadius: 4,
        ),
      ],
    );

    return Material(
      borderRadius: kDefaultBorderRadius,
      elevation: 4,
      color: Colors.transparent,
      // clip the container and the custom paint
      child: ClipRRect(
        borderRadius: kDefaultBorderRadius,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color(0xff8B00FD),
                Color(0xffBC0492),
                Color(0xffFD0A04),
              ],
            ),
          ),
          child: CustomPaint(
            painter: _HarpyProCardPainter(),
            // material for the ink well
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: kDefaultBorderRadius,
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: DefaultTextStyle(
                    style: textStyle,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const FlareIcon.shiningStar(size: 32),
                            const SizedBox(width: 8),
                            Text('harpy pro', style: headline),
                          ],
                        ),
                        if (children != null) ...<Widget>[
                          const SizedBox(height: 16),
                          ...children,
                        ],
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
class _HarpyProCardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint overlayPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset.zero,
        Offset(size.width, size.height),
        const <Color>[
          Color(0x77FD0A04),
          Color(0x77BC0492),
          Color(0x778B00FD),
        ],
        <double>[0, .5, 1],
      );

    final double width1 = size.width * 1 / 3;
    final double height1 = size.height * 1 / 3;

    final Path path1 = Path()
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

    final Path path2 = Path()
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

    canvas..drawPath(path1, overlayPaint)..drawPath(path2, overlayPaint);
    canvas
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
