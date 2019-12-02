import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/buttons.dart';
import 'package:harpy/components/widgets/shared/flare_icons.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:harpy/core/misc/flushbar_service.dart';
import 'package:harpy/core/misc/url_launcher.dart';
import 'package:harpy/harpy.dart';
import 'package:package_info/package_info.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen();

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final Map<String, GestureRecognizer> _recognizer = {};

  @override
  void initState() {
    super.initState();

    _recognizer["flutter"] = TapGestureRecognizer()
      ..onTap = () => launchUrl("https://flutter.dev");

    _recognizer["github"] = TapGestureRecognizer()
      ..onTap = () => launchUrl("https://github.com/robertodoering/harpy");

    _recognizer["email"] = TapGestureRecognizer()
      ..onTap = () =>
          launchUrl("mailto:rbydoering+harpy@gmail.com?subject=Harpy feedback");
  }

  @override
  void dispose() {
    super.dispose();
    _recognizer.values.forEach((recognizer) => recognizer.dispose());
  }

  List<Widget> _buildTitleWithLogo(Color textColor) {
    return [
      SizedBox(
        height: 100,
        child: FlareActor(
          "assets/flare/harpy_title.flr",
          animation: "show",
          color: textColor,
        ),
      ),
      const SizedBox(
        height: 100,
        child: FlareActor(
          "assets/flare/harpy_logo.flr",
          animation: "show",
        ),
      ),
    ];
  }

  Widget _buildIntroductionText(TextStyle linkStyle) {
    return Text.rich(TextSpan(
      children: [
        const TextSpan(text: "Harpy has been made with "),
        TextSpan(
          text: "Flutter",
          style: linkStyle,
          recognizer: _recognizer["flutter"],
        ),
        const TextSpan(text: " and is open source on "),
        TextSpan(
          text: "GitHub",
          style: linkStyle,
          recognizer: _recognizer["github"],
        ),
        const TextSpan(text: "."),
      ],
    ));
  }

  List<Widget> _buildProText(Color accentColor, TextStyle linkStyle) {
    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Expanded(
            child: Text(
                "To support the development of Harpy, please buy Harpy Pro "
                "in the Play Store."),
          ),
          const FlareIcon.shiningStar(size: 44),
        ],
      ),
      const SizedBox(height: 8),
      HarpyButton.raised(
        text: "Harpy Pro",
        backgroundColor: accentColor,
        dense: true,
        // todo: link to harpy pro
        onTap: () => app<FlushbarService>().info("Not yet available"),
      ),
    ];
  }

  List<Widget> _buildRateAppText(Color accentColor) {
    return [
      const Text("Please rate Harpy in the Play Store!"),
      const SizedBox(height: 8),
      HarpyButton.raised(
        text: "Rate Harpy",
        backgroundColor: accentColor,
        dense: true,
        // todo harpy free or pro playstore link
        onTap: () => app<FlushbarService>().info("Not yet available"),
      ),
    ];
  }

  List<Widget> _buildDeveloperText(Color accentColor, TextStyle linkStyle) {
    return [
      const Text("Developed by Roberto Doering"),
      Text.rich(TextSpan(
        text: "rbydoering@gmail.com",
        style: linkStyle,
        recognizer: _recognizer["email"],
      )),
      const SizedBox(height: 8),
      const Text("Thank you for your feedback and bug reports!"),
      const SizedBox(height: 8),
      HarpyButton.raised(
        text: "Contact",
        backgroundColor: accentColor,
        dense: true,
        onTap: () => launchUrl(
          "mailto:rbydoering+harpy@gmail.com?subject=Harpy feedback",
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final color = textTheme.body1.color;

    final linkStyle = textTheme.body1.copyWith(
      color: theme.accentColor,
      fontWeight: FontWeight.bold,
    );

    return HarpyScaffold(
      title: "About",
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ..._buildTitleWithLogo(color),
              _VersionCode(style: textTheme.subtitle),
              const Divider(height: 32),
              _buildIntroductionText(linkStyle),
              if (Harpy.isFree) ...[
                const Divider(height: 32),
                ..._buildProText(theme.accentColor, linkStyle)
              ],
              const Divider(height: 32),
              ..._buildRateAppText(theme.accentColor),
              const Divider(height: 32),
              ..._buildDeveloperText(theme.accentColor, linkStyle),
            ],
          ),
        ),
      ),
    );
  }
}

/// Gets the current version via [PackageInfo] and builds it as a [Text].
class _VersionCode extends StatefulWidget {
  const _VersionCode({
    this.style,
  });

  final TextStyle style;

  @override
  __VersionCodeState createState() => __VersionCodeState();
}

class __VersionCodeState extends State<_VersionCode> {
  String _version = "";

  Future<void> _getVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      _version = packageInfo.version;
    });
  }

  @override
  void initState() {
    super.initState();

    _getVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Text("Version $_version", style: widget.style);
  }
}
