import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:rby/rby.dart';

class DownloadDialog extends ConsumerStatefulWidget {
  const DownloadDialog({
    required this.initialName,
    required this.type,
  });

  final String initialName;
  final MediaType type;

  @override
  ConsumerState<DownloadDialog> createState() => _DownloadDialogState();
}

class _DownloadDialogState extends ConsumerState<DownloadDialog> {
  late String _name = widget.initialName;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      ref.read(downloadPathProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final downloadPath = ref.watch(downloadPathProvider);

    return RbyDialog(
      title: Text('download ${widget.type.name}'),
      contentPadding: theme.spacing.only(bottom: true),
      content: Column(
        children: [
          Padding(
            padding: theme.spacing.edgeInsets,
            child: _NameTextField(
              initialName: widget.initialName,
              onChanged: (value) => setState(() => _name = value),
            ),
          ),
          RbyListTile(
            leading: const Icon(CupertinoIcons.folder),
            title: const Text('download location'),
            subtitle: Text(downloadPath.fullPathForType(widget.type) ?? ''),
            onTap: () => showDialog<void>(
              context: context,
              builder: (_) => DownloadPathSelectionDialog(
                type: widget.type.name,
              ),
            ),
          ),
        ],
      ),
      actions: [
        RbyButton.text(
          label: const Text('cancel'),
          onTap: Navigator.of(context).pop,
        ),
        RbyButton.elevated(
          label: const Text('download'),
          onTap:
              _name.isNotEmpty ? () => Navigator.of(context).pop(_name) : null,
        ),
      ],
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

    _controller = TextEditingController(text: filename);
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
      inputFormatters: [FilteringTextInputFormatter.deny(invalidFilenameRegex)],
      decoration: InputDecoration(
        suffixText: _suffix,
        labelText: 'filename',
      ),
    );
  }
}
