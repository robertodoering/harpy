import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/rby/rby.dart';

/// A dialog to select one of a couple predefined external storage media
/// directories for a type of media.
///
/// For Android 11+, access to directories is limited to the media directories,
/// unless the `MANAGE_EXTERNAL_STORAGE` permission is requested.
/// Apps such as harpy can't request that permission if it's not required for
/// core feature. An update for harpy that allowed arbitrary storage location
/// selection was denied due to this.
///
/// See https://developer.android.com/training/data-storage/shared/media.
class DownloadPathSelectionDialog extends ConsumerStatefulWidget {
  const DownloadPathSelectionDialog({
    required this.type,
  });

  final String type;

  @override
  ConsumerState<DownloadPathSelectionDialog> createState() =>
      _DownloadPathSelectionDialogState();
}

class _DownloadPathSelectionDialogState
    extends ConsumerState<DownloadPathSelectionDialog> {
  @override
  Widget build(BuildContext context) {
    final display = ref.watch(displayPreferencesProvider);
    final downloadPath = ref.watch(downloadPathProvider);

    return Unfocus(
      child: AlertDialog(
        title: Text('${widget.type} download location'),
        contentPadding: display.edgeInsetsOnly(bottom: true),
        content: downloadPath.when(
          data: (mediaPaths, entries) {
            final entry = entries.firstWhereOrNull(
              (entry) => entry.type == widget.type,
            );

            if (entry != null) {
              return _PathSelection(
                type: widget.type,
                mediaPaths: mediaPaths,
                entry: entry,
              );
            } else {
              return const SizedBox();
              // return const LoadingDataError(
              //   message: Text('error loading download paths'),
              // );
            }
          },
          error: () => const SizedBox(),
          // error: () => const LoadingDataError(
          //   message: Text('error loading download paths'),
          // ),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class _PathSelection extends ConsumerStatefulWidget {
  const _PathSelection({
    required this.type,
    required this.mediaPaths,
    required this.entry,
  });

  final String type;
  final BuiltList<String> mediaPaths;
  final DownloadPathEntry entry;

  @override
  ConsumerState<_PathSelection> createState() => _PathSelectionState();
}

class _PathSelectionState extends ConsumerState<_PathSelection> {
  late String _selectedPath;
  late String _subDirectory;

  @override
  void initState() {
    super.initState();

    _selectedPath = widget.entry.path;
    _subDirectory = widget.entry.subDir;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HarpyListTile(
            title: _SubDirectoryTextField(
              initialName: _subDirectory,
              onChanged: (value) => _subDirectory = value,
            ),
          ),
          ...widget.mediaPaths.map(
            (mediaPath) => HarpyRadioTile<String>(
              title: Text(mediaPath.split('/').last),
              subtitle: Text(mediaPath),
              value: mediaPath,
              groupValue: _selectedPath,
              onChanged: (value) {
                setState(() => _selectedPath = value);
              },
            ),
          ),
          verticalSpacer,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: const Text('cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();

                  ref.watch(downloadPathProvider.notifier).updateEntry(
                        type: widget.type,
                        path: _selectedPath,
                        subDir: _subDirectory,
                      );

                  Navigator.of(context).pop();
                },
                child: const Text('confirm'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubDirectoryTextField extends StatefulWidget {
  const _SubDirectoryTextField({
    required this.initialName,
    required this.onChanged,
  });

  final String initialName;
  final ValueChanged<String> onChanged;

  @override
  _SubDirectoryTextFieldState createState() => _SubDirectoryTextFieldState();
}

class _SubDirectoryTextFieldState extends State<_SubDirectoryTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = FilenameEditingController(text: widget.initialName)
      ..addListener(() {
        // rebuild to update clear button
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        label: const Text('sub directory'),
        suffixIcon: IconButton(
          onPressed: _controller.text.isNotEmpty
              ? () {
                  _controller.clear();
                  widget.onChanged('');
                  FocusScope.of(context).unfocus();
                }
              : null,
          icon: const Icon(CupertinoIcons.xmark),
        ),
      ),
    );
  }
}
