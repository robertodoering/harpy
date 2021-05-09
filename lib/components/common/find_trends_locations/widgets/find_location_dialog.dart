import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

/// A dialog that allows the user to find relevant trends locations.
///
/// The user can use their geolocation data to find nearby locations or enter
/// custom geolocation coordinates.
class FindLocationDialog extends StatefulWidget {
  const FindLocationDialog({
    Key? key,
  }) : super(key: key);

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
          removeFocus(context);

          if (tabController.index == 0) {
            Navigator.of(context).pop();
          } else {
            _validForm = false;
            _latitude = null;
            _longitude = null;
            tabController.animateTo(0);
            bloc.add(const ClearFoundTrendsLocations());
          }
        },
      ),
    ];
  }

  void _onConfirm(FindTrendsLocationsBloc bloc, TabController tabController) {
    removeFocus(context);

    tabController.animateTo(3);

    bloc.add(
      FindTrendsLocations(
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
            setState(() => tabController.animateTo(1));
          },
          onSelectCustomLocation: () {
            setState(() => tabController.animateTo(2));
          },
        ),
        const FindNearbyLocations(),
        FindCustomLocationContent(
          formKey: _form,
          onFormChanged: _onFormChanged,
          onLatitudeChanged: (latitude) => _latitude = latitude,
          onLongitudeChanged: (longitude) => _longitude = longitude,
          onConfirm: _enableConfirm && !bloc.state.hasLoadedData
              ? () => _onConfirm(bloc, tabController)
              : null,
        ),
        const FoundLocationsContent(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<FindTrendsLocationsBloc>();

    return DefaultTabController(
      length: 4,
      child: Builder(
        builder: (context) {
          final tabController = DefaultTabController.of(context)!;

          return GestureDetector(
            // remove focus on background tap
            onTap: () => removeFocus(context),
            child: HarpyDialog(
              title: const Text('find location'),
              contentPadding: const EdgeInsets.symmetric(vertical: 24),
              content: SizedBox(
                height: 200,
                child: _buildTabView(bloc, tabController),
              ),
              actions: _buildActions(bloc, tabController),
            ),
          );
        },
      ),
    );
  }
}
