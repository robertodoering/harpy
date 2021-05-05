import 'package:flutter/widgets.dart';

/// Clears the focus of any focused child.
void removeFocus(BuildContext context) {
  final FocusScopeNode currentFocus = FocusScope.of(context);

  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus!.unfocus();
  }
}
