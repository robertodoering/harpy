import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:provider/provider.dart';

class CustomThemeName extends StatefulWidget {
  const CustomThemeName();

  @override
  _CustomThemeNameState createState() => _CustomThemeNameState();
}

class _CustomThemeNameState extends State<CustomThemeName> {
  TextEditingController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final cubit = context.read<CustomThemeCubit>();

    _controller ??= TextEditingController(text: cubit.state.name)
      ..addListener(() => cubit.renameTheme(_controller!.text));
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;
    final cubit = context.watch<CustomThemeCubit>();

    return Padding(
      padding: config.edgeInsetsSymmetric(horizontal: true),
      child: TextField(
        controller: _controller,
        maxLength: 20,
        decoration: InputDecoration(
          errorText: cubit.validName ? null : 'invalid name',
        ),
      ),
    );
  }
}
