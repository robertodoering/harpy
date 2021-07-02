import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:provider/provider.dart';

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
    harpyRouteObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    harpyRouteObserver.unsubscribe(this);
    super.dispose();
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
      HapticFeedback.lightImpact();

      setState(() {
        themeBloc.add(ChangeThemeEvent(
          id: newThemeId,
          saveSelection: true,
        ));
      });
    }
  }

  void _editCustomTheme(ThemeBloc themeBloc, int themeId, int index) {
    final editingHarpyTheme = themeBloc.customThemes[index];

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
    final themeBloc = ThemeBloc.of(context);
    final config = context.watch<ConfigBloc>().state;

    final selectedThemeId = themeBloc.selectedThemeId;

    final children = <Widget>[
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
        padding: config.edgeInsets,
        itemCount: children.length,
        itemBuilder: (_, index) => children[index],
        separatorBuilder: (_, __) => defaultSmallVerticalSpacer,
      ),
    );
  }
}
