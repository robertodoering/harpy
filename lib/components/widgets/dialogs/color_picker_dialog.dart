import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({
    required this.color,
    this.allowTransparency = false,
    this.onColorChanged,
  });

  /// The initial picker color.
  final Color color;

  final bool allowTransparency;

  /// An optional callback which is invoked when the color picker changes its
  /// color.
  final ValueChanged<Color>? onColorChanged;

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color _color;

  @override
  void initState() {
    super.initState();

    _color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return HarpyDialog(
      animationType: DialogAnimationType.slide,
      contentPadding: EdgeInsets.zero,
      constrainActionSize: true,
      actions: [
        DialogAction<void>(
          text: 'discard',
          onTap: () => app<HarpyNavigator>().pop(widget.color),
        ),
        DialogAction<void>(
          text: 'select',
          onTap: () => app<HarpyNavigator>().pop(_color),
        ),
      ],
      content: CustomAnimatedSize(
        child: AnimatedSwitcher(
          duration: kShortAnimationDuration,
          child: HarpyColorPicker(
            color: _color,
            allowTransparency: widget.allowTransparency,
            onColorChanged: (color) {
              _color = color;
              widget.onColorChanged?.call(color);
            },
          ),
        ),
      ),
    );
  }
}

class HarpyColorPicker extends StatefulWidget {
  const HarpyColorPicker({
    required this.color,
    required this.onColorChanged,
    this.allowTransparency = false,
  });

  final Color color;
  final ValueChanged<Color> onColorChanged;
  final bool allowTransparency;

  @override
  _HarpyColorPickerState createState() => _HarpyColorPickerState();
}

class _HarpyColorPickerState extends State<HarpyColorPicker> {
  late Color _color;
  late HSVColor _hsvColor;

  @override
  void initState() {
    super.initState();

    _color = widget.color;
    _hsvColor = HSVColor.fromColor(widget.color);
  }

  void _onColorChanged(Color color) {
    removeFocus(context);

    setState(() => _color = color);

    widget.onColorChanged(color);
  }

  void _onHsvColorChanged(HSVColor hsvColor) {
    setState(() => _hsvColor = hsvColor);
    _onColorChanged(hsvColor.toColor());
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigBloc>().state;

    final children = {
      const HarpyTab(icon: Text('hue')): Padding(
        padding: config.edgeInsetsSymmetric(horizontal: true),
        child: PaletteHuePicker(
          color: _hsvColor,
          onChanged: _onHsvColorChanged,
        ),
      ),
      const HarpyTab(icon: Text('wheel')): Padding(
        padding: EdgeInsets.symmetric(
          horizontal: config.paddingValue * 2,
        ),
        child: WheelPicker(
          color: _hsvColor,
          onChanged: _onHsvColorChanged,
        ),
      ),
      const HarpyTab(icon: Text('rgb')): Padding(
        padding: config.edgeInsetsSymmetric(horizontal: true),
        child: RGBPicker(
          color: _color,
          onChanged: _onColorChanged,
        ),
      ),
      const HarpyTab(icon: Text('hsv')): Padding(
        padding: config.edgeInsetsSymmetric(horizontal: true),
        child: HSVPicker(
          color: _hsvColor,
          onChanged: _onHsvColorChanged,
        ),
      ),
    };

    return GestureDetector(
      onTap: () => removeFocus(context),
      child: DefaultTabController(
        initialIndex: 0, // todo: remember index in preferences
        length: children.length,
        child: Column(
          children: [
            defaultVerticalSpacer,
            HarpyTabBar(
              tabs: children.keys.toList(),
            ),
            defaultVerticalSpacer,
            _ColorPickerHex(
              color: _color,
              onColorChanged: _onColorChanged,
            ),
            defaultVerticalSpacer,
            SizedBox(
              height: 340,
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: children.values.toList(),
              ),
            ),
            defaultVerticalSpacer,
            if (widget.allowTransparency)
              Padding(
                padding: config.edgeInsetsSymmetric(horizontal: true),
                child: AlphaPicker(
                  alpha: _color.alpha,
                  onChanged: (alpha) => _onHsvColorChanged(
                    _hsvColor.withAlpha(alpha / 255),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ColorPickerHex extends StatelessWidget {
  const _ColorPickerHex({
    required this.color,
    required this.onColorChanged,
  });

  final Color color;
  final ValueChanged<Color> onColorChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        defaultHorizontalSpacer,
        defaultHorizontalSpacer,
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: theme.dividerColor),
          ),
        ),
        defaultHorizontalSpacer,
        Expanded(
          child: HexPicker(
            color: color,
            onChanged: onColorChanged,
          ),
        ),
      ],
    );
  }
}
