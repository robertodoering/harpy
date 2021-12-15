import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Content for the [FindLocationDialog] that allow the user to enter custom
/// geolocation coordinates to search locations for.
class FindCustomLocationContent extends StatelessWidget {
  const FindCustomLocationContent({
    required this.formKey,
    required this.onFormChanged,
    required this.onLongitudeChanged,
    required this.onLatitudeChanged,
    required this.onConfirm,
  });

  final GlobalKey<FormState> formKey;
  final VoidCallback onFormChanged;
  final ValueChanged<String> onLongitudeChanged;
  final ValueChanged<String> onLatitudeChanged;
  final VoidCallback? onConfirm;

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      counterText: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Form(
      key: formKey,
      onChanged: onFormChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              children: [
                TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  maxLength: 8,
                  decoration: _decoration('latitude'),
                  textInputAction: TextInputAction.next,
                  onEditingComplete: node.nextFocus,
                  validator: FindTrendsLocationsBloc.latitudeValidator,
                  onChanged: onLatitudeChanged,
                ),
                verticalSpacer,
                TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  maxLength: 8,
                  decoration: _decoration('longitude'),
                  textInputAction: TextInputAction.done,
                  onEditingComplete: node.unfocus,
                  validator: FindTrendsLocationsBloc.longitudeValidator,
                  onChanged: onLongitudeChanged,
                ),
                verticalSpacer,
                HarpyButton.flat(
                  text: const Text('confirm'),
                  onTap: onConfirm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
