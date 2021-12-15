import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

/// A dialog that allows the user to find relevant trends locations.
///
/// The user can use their geolocation data to find nearby locations or enter
/// custom geolocation coordinates.
class FindLocationDialog extends StatefulWidget {
  const FindLocationDialog();

  @override
  _FindLocationDialogState createState() => _FindLocationDialogState();
}

class _FindLocationDialogState extends State<FindLocationDialog> {
  final _form = GlobalKey<FormState>();

  bool _validForm = false;

  String? _latitude;
  String? _longitude;

  bool get _enableConfirm =>
      _validForm &&
      _latitude != null &&
      _latitude!.isNotEmpty &&
      _longitude != null &&
      _longitude!.isNotEmpty;

  List<Widget> _buildActions(
    FindTrendsLocationsBloc bloc,
    TabController tabController,
  ) {
    return [
      DialogAction<void>(
        text: 'back',
        onTap: () {
          FocusScope.of(context).unfocus();

          if (tabController.index == 0) {
            Navigator.of(context).pop();
          } else {
            setState(() {
              _validForm = false;
              _latitude = null;
              _longitude = null;
            });

            // wait for the view to rebuild before navigating away
            // this ensures that the confirm button gets disabled
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              tabController.animateTo(0);
              bloc.add(const FindTrendsLocationsEvent.clear());
            });
          }
        },
      ),
    ];
  }

  void _onConfirm(FindTrendsLocationsBloc bloc, TabController tabController) {
    FocusScope.of(context).unfocus();

    tabController.animateTo(2);

    bloc.add(
      FindTrendsLocationsEvent.search(
        latitude: _latitude!,
        longitude: _longitude!,
      ),
    );
  }

  void _onFormChanged() {
    setState(() {
      _validForm = _form.currentState!.validate();
    });
  }

  Widget _buildTabView(
    FindTrendsLocationsBloc bloc,
    TabController tabController,
  ) {
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        SelectFindMethodContent(
          onSelectNearLocation: () {
            bloc.add(const FindTrendsLocationsEvent.nearby());
            setState(() => tabController.animateTo(2));
          },
          onSelectCustomLocation: () {
            setState(() => tabController.animateTo(1));
          },
        ),
        FindCustomLocationContent(
          formKey: _form,
          onFormChanged: _onFormChanged,
          onLatitudeChanged: (latitude) => _latitude = latitude,
          onLongitudeChanged: (longitude) => _longitude = longitude,
          onConfirm:
              _enableConfirm ? () => _onConfirm(bloc, tabController) : null,
        ),
        const FoundLocationsContent(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<FindTrendsLocationsBloc>();

    return DefaultTabController(
      length: 3,
      child: Builder(
        builder: (context) {
          final tabController = DefaultTabController.of(context)!;

          return GestureDetector(
            // remove focus on background tap
            onTap: FocusScope.of(context).unfocus,
            child: HarpyDialog(
              title: const Text('find location'),
              contentPadding: const EdgeInsets.symmetric(vertical: 24),
              actions: _buildActions(bloc, tabController),
              content: SizedBox(
                height: 200,
                child: _buildTabView(bloc, tabController),
              ),
            ),
          );
        },
      ),
    );
  }
}
