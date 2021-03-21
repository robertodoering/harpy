import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';

class ThemeSelectionScreen extends StatefulWidget {
  const ThemeSelectionScreen();

  static const String route = 'theme_selection';

  @override
  _ThemeSelectionScreenState createState() => _ThemeSelectionScreenState();
}

class _ThemeSelectionScreenState extends State<ThemeSelectionScreen>
    with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    app<HarpyNavigator>().routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    super.dispose();
    app<HarpyNavigator>().routeObserver.unsubscribe(this);
  }

  @override
  void didPopNext() {
    // rebuild in case custom themes changes
    setState(() {});
  }

  void _changeTheme(
    ThemeBloc themeBloc,
    int selectedThemeId,
    int newThemeId,
  ) {
    if (selectedThemeId != newThemeId) {
      setState(() {
        themeBloc.add(ChangeThemeEvent(
          id: newThemeId,
          saveSelection: true,
        ));
      });
    }
  }

  void _editCustomTheme(ThemeBloc themeBloc, int themeId, int index) {
    final HarpyTheme editingHarpyTheme = themeBloc.customThemes[index];

    // update system ui when editing theme
    themeBloc.add(UpdateSystemUi(theme: editingHarpyTheme));

    app<HarpyNavigator>().pushCustomTheme(
      themeData: HarpyThemeData.fromHarpyTheme(editingHarpyTheme),
      themeId: themeId,
    );
  }

  List<Widget> _buildPredefinedThemes(
    ThemeBloc themeBloc,
    int selectedThemeId,
  ) {
    return <Widget>[
      for (int i = 0; i < predefinedThemes.length; i++)
        ThemeCard(
          predefinedThemes[i],
          selected: i == selectedThemeId,
          onTap: () => _changeTheme(themeBloc, selectedThemeId, i),
        ),
    ];
  }

  List<Widget> _buildCustomThemes(
    ThemeBloc themeBloc,
    int selectedThemeId,
  ) {
    return <Widget>[
      for (int i = 0; i < themeBloc.customThemes.length; i++)
        ThemeCard(
          themeBloc.customThemes[i],
          selected: i + 10 == selectedThemeId,
          canEdit: true,
          onTap: () => selectedThemeId == i + 10
              ? _editCustomTheme(themeBloc, i + 10, i)
              : _changeTheme(themeBloc, selectedThemeId, i + 10),
          onEdit: () => _editCustomTheme(themeBloc, i + 10, i),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ThemeBloc themeBloc = ThemeBloc.of(context);
    final int selectedThemeId = themeBloc.selectedThemeId;

    final List<Widget> children = <Widget>[
      ..._buildPredefinedThemes(themeBloc, selectedThemeId),
      ..._buildCustomThemes(
        themeBloc,
        selectedThemeId,
      ),
      const AddCustomThemeCard(),
    ];

    return HarpyScaffold(
      title: 'theme selection',
      buildSafeArea: true,
      body: ListView.separated(
        padding: DefaultEdgeInsets.all(),
        itemCount: children.length,
        itemBuilder: (BuildContext context, int index) => children[index],
        separatorBuilder: (BuildContext context, int index) =>
            defaultSmallVerticalSpacer,
      ),
    );
  }
}
