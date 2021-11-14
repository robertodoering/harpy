import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

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
    FocusScope.of(context).unfocus();

    setState(() => _color = color);

    widget.onColorChanged(color);
  }

  void _onHsvColorChanged(HSVColor hsvColor) {
    setState(() => _hsvColor = hsvColor);
    _onColorChanged(hsvColor.toColor());
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;

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

    final initialIndex =
        app<LayoutPreferences>().colorPickerTab.clamp(0, children.length - 1);

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: DefaultTabController(
        initialIndex: initialIndex,
        length: children.length,
        child: _ColorPickerTabListener(
          child: Column(
            children: [
              verticalSpacer,
              HarpyTabBar(tabs: children.keys.toList()),
              verticalSpacer,
              _ColorPickerHeader(
                color: _color,
                onColorChanged: _onColorChanged,
              ),
              verticalSpacer,
              SizedBox(
                height: 340,
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: children.values.toList(),
                ),
              ),
              verticalSpacer,
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
      ),
    );
  }
}

class _ColorPickerHeader extends StatelessWidget {
  const _ColorPickerHeader({
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
        horizontalSpacer,
        horizontalSpacer,
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: theme.dividerColor),
          ),
        ),
        horizontalSpacer,
        Expanded(
          child: Theme(
            data: theme.copyWith(
              inputDecorationTheme: const InputDecorationTheme(),
            ),
            child: HexPicker(
              color: color,
              onChanged: onColorChanged,
            ),
          ),
        ),
      ],
    );
  }
}

/// Listens to the default tab controller and updates the color picker tab
/// preferences on change.
class _ColorPickerTabListener extends StatefulWidget {
  const _ColorPickerTabListener({
    required this.child,
  });

  final Widget child;

  @override
  _ColorPickerTabListenerState createState() => _ColorPickerTabListenerState();
}

class _ColorPickerTabListenerState extends State<_ColorPickerTabListener> {
  TabController? _controller;
  int _index = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _controller ??= DefaultTabController.of(context)?..addListener(_listener);
    _index = _controller!.index;
  }

  @override
  void dispose() {
    _controller!.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    if (_controller!.index != _index) {
      _index = _controller!.index;
      app<LayoutPreferences>().colorPickerTab = _index;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
