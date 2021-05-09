import 'package:flutter/cupertino.dart';
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
    Key? key,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final VoidCallback onFormChanged;
  final ValueChanged<String> onLongitudeChanged;
  final ValueChanged<String> onLatitudeChanged;

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      counterText: '',
      border: const OutlineInputBorder(
        borderRadius: kDefaultBorderRadius,
      ),
    );
  }

  String? _validator(String? value) {
    if (value != null && value.isNotEmpty) {
      final coord = double.tryParse(value);

      if (coord != null) {
        if (coord > 180 || coord < -180) {
          return 'invalid';
        } else {
          return null;
        }
      } else {
        return 'invalid';
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Form(
        key: formKey,
        onChanged: onFormChanged,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
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
                validator: _validator,
                onChanged: onLatitudeChanged,
              ),
              defaultVerticalSpacer,
              TextFormField(
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                maxLength: 8,
                decoration: _decoration('longitude'),
                textInputAction: TextInputAction.done,
                onEditingComplete: node.unfocus,
                validator: _validator,
                onChanged: onLongitudeChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
