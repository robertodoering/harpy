import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/buttons.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:harpy/components/widgets/shared/service_provider.dart';
import 'package:harpy/models/compose_tweet_model.dart';
import 'package:provider/provider.dart';

class ComposeTweetScreen extends StatefulWidget {
  @override
  _ComposeTweetScreenState createState() => _ComposeTweetScreenState();
}

class _ComposeTweetScreenState extends State<ComposeTweetScreen> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController()..addListener(() => setState(() {}));
  }

  Widget _buildTextField(ComposeTweetModel model) {
    return TextField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      controller: _controller,
      autofocus: true,
      maxLines: null,
      expands: true,
      enabled: !model.tweeting,
      textAlignVertical: TextAlignVertical.top,
      style: Theme.of(context).textTheme.body1,
    );
  }

  Widget _buildMedia(ComposeTweetModel model) {
    if (model.media.isEmpty) {
      return Container();
    }

    return Expanded(
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 8),
        children: model.media.map((file) {
          final index = model.media.indexOf(file);
          final length = model.media.length;

          final badFile = model.isBadFile(file);
          final decoration = badFile
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    width: 3,
                    color: Colors.red,
                  ),
                )
              : null;

          return Padding(
            padding: EdgeInsets.only(right: index < length - 1 ? 8 : 0),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: decoration,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(file),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: ClipOval(
                      child: Material(
                        color: Colors.black.withOpacity(0.5),
                        child: InkWell(
                          onTap: () => model.removeMedia(index),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.clear,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionBar(ComposeTweetModel model) {
    final enableTweet = !model.tweeting &&
        (model.media.isNotEmpty || _controller.text.trim().isNotEmpty);

    return Column(
      children: <Widget>[
        Divider(),
        Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.image),
              onPressed: model.tweeting ? null : model.addMedia,
            ),
            Spacer(),
            RaisedHarpyButton(
              text: "Tweet",
              dense: true,
              onTap: enableTweet ? () => model.tweet(_controller.text) : null,
            ),
          ],
        ),
        Divider(),
      ],
    );
  }

  Widget _buildBody(ComposeTweetModel model) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Column(
              children: <Widget>[
                Expanded(flex: 2, child: _buildTextField(model)),
                _buildMedia(model),
                _buildActionBar(model),
              ],
            ),
          ),
        ),
        model.tweeting ? const LinearProgressIndicator() : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider = ServiceProvider.of(context);

    return HarpyScaffold(
      title: "New Tweet",
      body: ChangeNotifierProvider<ComposeTweetModel>(
        builder: (_) => ComposeTweetModel(
          tweetService: serviceProvider.data.tweetService,
          mediaService: serviceProvider.data.mediaService,
          onTweeted: _controller.clear,
        ),
        child: Consumer<ComposeTweetModel>(
          builder: (context, model, _) => _buildBody(model),
        ),
      ),
    );
  }
}
