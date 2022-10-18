import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';
import 'package:tuple/tuple.dart';

/// Content for the [FindTrendsLocationDialog] for entering custom coordinates.
class FindCustomTrendsLocation extends StatefulWidget {
  const FindCustomTrendsLocation({
    required this.onSearch,
  });

  final ValueChanged<Tuple2<String, String>> onSearch;

  @override
  State<FindCustomTrendsLocation> createState() =>
      _FindCustomTrendsLocationState();
}

class _FindCustomTrendsLocationState extends State<FindCustomTrendsLocation> {
  final _form = GlobalKey<FormState>();

  String _latitude = '';
  String _longitude = '';

  bool get _validate =>
      _latitude.isNotEmpty &&
      _longitude.isNotEmpty &&
      (_form.currentState?.validate() ?? false);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _form,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SingleChildScrollView(
        child: Column(
          children: [
            AnimatedSize(
              duration: theme.animation.short,
              alignment: AlignmentDirectional.topCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: theme.spacing.small,
                  horizontal: theme.spacing.base,
                ),
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      maxLength: 8,
                      decoration: const InputDecoration(
                        labelText: 'latitude',
                        hintText: '35.652',
                        counterText: '',
                      ),
                      textInputAction: TextInputAction.next,
                      onEditingComplete: FocusScope.of(context).nextFocus,
                      validator: _latitudeValidator,
                      onChanged: (value) => setState(() => _latitude = value),
                    ),
                    VerticalSpacer.normal,
                    TextFormField(
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      maxLength: 8,
                      decoration: const InputDecoration(
                        labelText: 'longitude',
                        hintText: '139.839',
                        counterText: '',
                      ),
                      textInputAction: TextInputAction.done,
                      onEditingComplete: FocusScope.of(context).unfocus,
                      validator: _longitudeValidator,
                      onChanged: (value) => setState(() => _longitude = value),
                    ),
                    VerticalSpacer.normal,
                  ],
                ),
              ),
            ),
            RbyButton.elevated(
              label: const Text('confirm'),
              onTap: _validate
                  ? () => widget.onSearch(Tuple2(_latitude, _longitude))
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

/// Validator for a text field that verifies the [value] is a valid
/// latitude value. (0 to 90 deg)
String? _latitudeValidator(String? value) {
  if (value != null && value.isNotEmpty) {
    return _verifyRange(
      double.tryParse(value),
      low: 0,
      high: 90,
      errorMessage: 'invalid latitude',
    );
  } else {
    return null;
  }
}

/// Validator for a text field that verifies the [value] is a valid
/// longitude value. (-180 to 180 deg)
String? _longitudeValidator(String? value) {
  if (value != null && value.isNotEmpty) {
    return _verifyRange(
      double.tryParse(value),
      low: -180,
      high: 180,
      errorMessage: 'invalid longitude',
    );
  } else {
    return null;
  }
}

String? _verifyRange(
  double? value, {
  required double low,
  required double high,
  required String errorMessage,
}) {
  if (value != null) {
    if (value < low || value > high) {
      // out of range
      return errorMessage;
    } else {
      // valid
      return null;
    }
  } else {
    // invalid value
    return errorMessage;
  }
}
