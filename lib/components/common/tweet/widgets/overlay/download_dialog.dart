import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';

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
    required this.type,
  });

  final String initialName;
  final MediaType type;

  @override
  State<DownloadDialog> createState() => _DownloadDialogState();
}

class _DownloadDialogState extends State<DownloadDialog> {
  late String _name;

  @override
  void initState() {
    super.initState();

    _name = widget.initialName;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<DownloadPathCubit>();
    final state = cubit.state;

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: HarpyDialog(
        title: Text('download ${widget.type.name}'),
        contentPadding: EdgeInsets.zero,
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
              title: const Text('download location'),
              subtitle: Text(state.fullPathForType(widget.type) ?? ''),
              onTap: () => showDialog<void>(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: cubit,
                  child: DownloadPathSelectionDialog(type: widget.type.name),
                ),
              ),
            ),
          ],
        ),
        actions: [
          DialogAction<void>(
            text: 'cancel',
            onTap: Navigator.of(context).pop,
          ),
          DialogAction(
            result: _name.isEmpty
                ? null
                : DownloadDialogSelection(
                    name: _name,
                    path: state.fullPathForType(widget.type) ?? '',
                  ),
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

    _controller = FilenameEditingController(text: filename);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: (value) {
        if (value.isNotEmpty && _suffix != null) {
          // append the suffix to the text field value if it is not empty
          widget.onChanged('$value$_suffix');
        } else {
          widget.onChanged(value);
        }
      },
      decoration: InputDecoration(
        suffixText: _suffix,
        labelText: 'filename',
      ),
    );
  }
}
