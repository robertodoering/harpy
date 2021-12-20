import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// The return value of the [DownloadDialog].
class DownloadDialogSelection {
  const DownloadDialogSelection({
    required this.name,
    required this.path,
  });

  final String name;
  final String path;
}

/// Allows customizing the name and path of a downloaded file.
class DownloadDialog extends StatefulWidget {
  const DownloadDialog({
    required this.initialName,
    required this.initialPath,
  });

  final String initialName;
  final String initialPath;

  @override
  State<DownloadDialog> createState() => _DownloadDialogState();
}

class _DownloadDialogState extends State<DownloadDialog> {
  late String _path;
  late String _name;

  @override
  void initState() {
    super.initState();

    _path = widget.initialPath;
    _name = widget.initialName;
  }

  Future<void> _selectPath() async {
    final path = await FilePicker.platform.getDirectoryPath();

    if (path != null) {
      if (path.isEmpty || path == '/') {
        app<MessageService>().show('unable to access directory');
      } else {
        setState(() => _path = path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: HarpyDialog(
        contentPadding: const EdgeInsets.symmetric(vertical: 24),
        content: Column(
          children: [
            HarpyListTile(
              title: _NameTextField(
                initialName: widget.initialName,
                onChanged: (value) => setState(() => _name = value),
              ),
            ),
            HarpyListTile(
              leading: const Icon(CupertinoIcons.folder),
              title: const Text('download path'),
              subtitle: Text(_path),
              onTap: _selectPath,
            ),
          ],
        ),
        actions: [
          DialogAction<void>(
            text: 'cancel',
            onTap: Navigator.of(context).pop,
          ),
          DialogAction(
            result: _path.isEmpty || _name.isEmpty
                ? null
                : DownloadDialogSelection(name: _name, path: _path),
            text: 'download',
          ),
        ],
      ),
    );
  }
}

class _NameTextField extends StatefulWidget {
  const _NameTextField({
    required this.initialName,
    required this.onChanged,
  });

  final String initialName;
  final ValueChanged<String> onChanged;

  @override
  _NameTextFieldState createState() => _NameTextFieldState();
}

class _NameTextFieldState extends State<_NameTextField> {
  late TextEditingController _controller;
  late String? _suffix;

  @override
  void initState() {
    super.initState();

    String? filename;

    if (widget.initialName.contains('.')) {
      final segments = widget.initialName.split('.');

      if (segments.length == 2) {
        filename = segments[0];
        _suffix = '.${segments[1]}';
      }
    }

    _controller = _FilenameEditingController(text: filename);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: _controller,
      onChanged: (value) {
        if (value.isNotEmpty && _suffix != null) {
          // append the suffix to the text field value if it is not empty
          widget.onChanged('$value.$_suffix');
        } else {
          widget.onChanged(value);
        }
      },
      decoration: InputDecoration(
        suffixText: _suffix,
        contentPadding: EdgeInsets.zero,
        border: const UnderlineInputBorder(),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.dividerColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.colorScheme.primary),
        ),
      ),
    );
  }
}

/// Prevents adding characters that are invalid in a file name.
///
/// What characters are invalid depend on the file system. Invalid characters
/// that we check for are `|\\?*<":>+[]/\'`.
class _FilenameEditingController extends TextEditingController {
  _FilenameEditingController({String? text}) : super(text: text);

  /// A single capturing group with invalid filename characters.
  ///
  /// We use a multiline string since both ' and " are used in the group.
  final _invalidFilenameRegex = RegExp(r'''[|\\?*<":>+\[\]/']''');

  @override
  set value(TextEditingValue newValue) {
    if (!newValue.text.contains(_invalidFilenameRegex)) {
      super.value = newValue;
    }
  }
}
