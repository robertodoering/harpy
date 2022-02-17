import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

// TODO: fork `flutter_colorpicker` package for style improvements

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
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends ConsumerState<ColorPickerDialog> {
  late Color _color;

  @override
  void initState() {
    super.initState();

    _color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    final harpyTheme = ref.watch(harpyThemeProvider);

    return HarpyDialog(
      contentPadding: EdgeInsets.zero,
      content: ClipRRect(
        borderRadius: harpyTheme.borderRadius,
        child: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: widget.color,
            enableAlpha: widget.enableAlpha,
            pickerAreaBorderRadius: harpyTheme.borderRadius,
            hexInputBar: true,
            labelTypes: const [],
            onColorChanged: (color) {
              _color = color;
              widget.onColorChanged?.call(color);
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(widget.color),
          child: const Text('discard'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_color),
          child: const Text('select'),
        ),
      ],
    );
  }
}
