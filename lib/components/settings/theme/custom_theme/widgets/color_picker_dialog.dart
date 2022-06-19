import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class ColorPickerDialog extends ConsumerStatefulWidget {
  const ColorPickerDialog({
    required this.color,
    this.enableAlpha = false,
    this.onColorChanged,
  });

  final Color color;
  final bool enableAlpha;
  final ValueChanged<Color>? onColorChanged;

  @override
  ConsumerState<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends ConsumerState<ColorPickerDialog> {
  late Color _color = widget.color;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final harpyTheme = ref.watch(harpyThemeProvider);
    final display = ref.watch(displayPreferencesProvider);

    return HarpyDialog(
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      content: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (_, constraints) => HarpyColorPicker(
            pickerColor: widget.color,
            contentPadding: display.paddingValue,
            enableAlpha: widget.enableAlpha,
            pickerAreaBorderRadius: harpyTheme.borderRadius,
            colorPickerWidth: mediaQuery.orientation == Orientation.portrait
                ? constraints.maxWidth
                : 200,
            onColorChanged: (color) {
              _color = color;
              widget.onColorChanged?.call(color);
            },
          ),
        ),
      ),
      actions: [
        HarpyButton.text(
          label: const Text('discard'),
          onTap: () => Navigator.of(context).pop(widget.color),
        ),
        HarpyButton.elevated(
          label: const Text('select'),
          onTap: () => Navigator.of(context).pop(_color),
        ),
      ],
    );
  }
}
