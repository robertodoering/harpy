import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

class CustomThemeName extends ConsumerStatefulWidget {
  const CustomThemeName({
    required this.notifier,
  });

  final CustomThemeNotifier notifier;

  @override
  ConsumerState<CustomThemeName> createState() => _CustomThemeNameState();
}

class _CustomThemeNameState extends ConsumerState<CustomThemeName> {
  TextEditingController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _controller ??= TextEditingController(
      text: ref.read(harpyThemeProvider).data.name,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      maxLength: 20,
      decoration: InputDecoration(
        errorText: widget.notifier.validName ? null : 'invalid name',
      ),
      onChanged: widget.notifier.rename,
    );
  }
}
