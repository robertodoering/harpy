import 'package:flutter/material.dart';
import 'package:harpy/components/authentication/bloc/authentication_bloc.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/common/misc/harpy_scaffold.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/components/tweet/widgets/tweet/content/author_row.dart';

class ComposeScreen extends StatefulWidget {
  const ComposeScreen();

  static const String route = 'compose_screen';

  @override
  _ComposeScreenState createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
  }

  Widget _buildActionRow() {
    return Row(
      children: <Widget>[
        HarpyButton.flat(
          padding: DefaultEdgeInsets.all(),
          icon: const Icon(Icons.image),
          iconSize: 20,
          onTap: () {},
        ),
        defaultSmallHorizontalSpacer,
        HarpyButton.flat(
          padding: DefaultEdgeInsets.all(),
          icon: const Icon(Icons.add_a_photo),
          iconSize: 20,
          onTap: () {},
        ),
        defaultSmallHorizontalSpacer,
        HarpyButton.flat(
          padding: DefaultEdgeInsets.all(),
          text: const Text('@', style: TextStyle(fontSize: 20)),
          onTap: () => _controller.text += '@',
        ),
        defaultSmallHorizontalSpacer,
        HarpyButton.flat(
          padding: DefaultEdgeInsets.all(),
          text: const Text('#', style: TextStyle(fontSize: 20)),
          onTap: () => _controller.text += '#',
        ),
        const Spacer(),
        HarpyButton.flat(
          padding: DefaultEdgeInsets.all(),
          icon: const Icon(Icons.send),
          iconSize: 20,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildTextField(ThemeData theme) {
    return Padding(
      padding: DefaultEdgeInsets.symmetric(horizontal: true),
      child: TextField(
        controller: _controller,
        style: theme.textTheme.bodyText1,
        minLines: 4,
        maxLines: null,
        decoration: const InputDecoration(
          hintText: "What's happening?",
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AuthenticationBloc authBloc = AuthenticationBloc.of(context);

    return HarpyScaffold(
      title: 'Compose Tweet',
      body: Padding(
        padding: DefaultEdgeInsets.all(),
        child: Card(
          elevation: 0,
          child: Column(
            children: <Widget>[
              Padding(
                padding: DefaultEdgeInsets.all(),
                child: TweetAuthorRow(
                  authBloc.authenticatedUser,
                  enableUserTap: false,
                ),
              ),
              _buildTextField(theme),
              const Spacer(),
              _buildActionRow(),
            ],
          ),
        ),
      ),
    );
  }
}
