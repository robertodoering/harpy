import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

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
class DownloadPathSelectionDialog extends StatelessWidget {
  const DownloadPathSelectionDialog({
    required this.type,
  });

  final String type;

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<DownloadPathCubit>();

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: HarpyDialog(
        animationType: DialogAnimationType.slide,
        title: Text('$type download location'),
        contentPadding: const EdgeInsets.only(top: 24),
        content: SizedBox(
          height: 450,
          child: cubit.state.when(
            data: (mediaPaths, entries) {
              final entry = entries.firstWhereOrNull(
                (entry) => entry.type == type,
              );

              if (entry != null) {
                return _PathSelection(
                  type: type,
                  cubit: cubit,
                  mediaPaths: mediaPaths,
                  entry: entry,
                );
              } else {
                return const LoadingDataError(
                  message: Text('error loading download paths'),
                );
              }
            },
            error: () => const LoadingDataError(
              message: Text('error loading download paths'),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}

class _PathSelection extends StatefulWidget {
  const _PathSelection({
    required this.type,
    required this.cubit,
    required this.mediaPaths,
    required this.entry,
  });

  final String type;
  final DownloadPathCubit cubit;
  final BuiltList<String> mediaPaths;
  final DownloadPathEntry entry;

  @override
  State<_PathSelection> createState() => _PathSelectionState();
}

class _PathSelectionState extends State<_PathSelection> {
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
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              HarpyListTile(
                title: _SubDirectoryTextField(
                  initialName: _subDirectory,
                  onChanged: (value) => _subDirectory = value,
                ),
              ),
              ...widget.mediaPaths.map(
                (mediaPath) => RadioListTile<String>(
                  title: Text(mediaPath.split('/').last),
                  subtitle: Text(mediaPath),
                  value: mediaPath,
                  groupValue: _selectedPath,
                  onChanged: (value) {
                    HapticFeedback.lightImpact();
                    setState(() => _selectedPath = value!);
                  },
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DialogAction<void>(
              text: 'cancel',
              onTap: Navigator.of(context).pop,
            ),
            DialogAction<void>(
              text: 'confirm',
              onTap: () {
                HapticFeedback.lightImpact();

                widget.cubit.updateEntry(
                  type: widget.type,
                  path: _selectedPath,
                  subDir: _subDirectory,
                );

                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ],
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
        suffixIcon: HarpyButton.flat(
          dense: true,
          icon: const Icon(CupertinoIcons.xmark),
          onTap: _controller.text.isNotEmpty
              ? () {
                  _controller.clear();
                  widget.onChanged('');
                  FocusScope.of(context).unfocus();
                }
              : null,
        ),
      ),
    );
  }
}
