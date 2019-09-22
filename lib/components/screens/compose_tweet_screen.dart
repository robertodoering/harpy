import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/buttons.dart';
import 'package:harpy/components/widgets/shared/scaffolds.dart';
import 'package:harpy/core/utils/file_utils.dart';
import 'package:harpy/models/compose_tweet_model.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

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
        padding: const EdgeInsets.only(top: 8),
        children: model.media
            .map((file) => _ComposeTweetMedia(model: model, media: file))
            .toList(),
      ),
    );
  }

  Widget _buildActionBar(ComposeTweetModel model) {
    final enableTweet = !model.tweeting &&
        (model.media.isNotEmpty || _controller.text.trim().isNotEmpty);

    return Column(
      children: <Widget>[
        const Divider(),
        Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.image),
              onPressed: model.canAddMedia ? model.addMedia : null,
            ),
            Spacer(),
            HarpyButton.raised(
              text: "Tweet",
              dense: true,
              onTap: enableTweet ? () => model.tweet(_controller.text) : null,
            ),
          ],
        ),
        const Divider(),
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
    return HarpyScaffold(
      title: "New Tweet",
      body: ChangeNotifierProvider<ComposeTweetModel>(
        builder: (_) => ComposeTweetModel(
          onTweeted: _controller.clear,
        ),
        child: Consumer<ComposeTweetModel>(
          builder: (context, model, _) => _buildBody(model),
        ),
      ),
    );
  }
}

/// Builds the image or a video player for the media.
class _ComposeTweetMedia extends StatefulWidget {
  const _ComposeTweetMedia({
    @required this.model,
    @required this.media,
  });

  final ComposeTweetModel model;
  final File media;

  @override
  __ComposeTweetMediaState createState() => __ComposeTweetMediaState();
}

class __ComposeTweetMediaState extends State<_ComposeTweetMedia>
    with SingleTickerProviderStateMixin<_ComposeTweetMedia> {
  VideoPlayerController _controller;

  FileType _type;
  int _index;
  bool _badFile;

  Widget _buildImage() {
    return Image.file(widget.media);
  }

  Widget _buildVideo() {
    return AnimatedSize(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      child: AspectRatio(
        aspectRatio: _controller.value?.aspectRatio ?? 1,
        child: _controller.value.initialized
            ? VideoPlayer(_controller)
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Theme.of(context).disabledColor),
                ),
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
      ),
    );
  }

  @override
  void initState() {
    _type = getFileType(widget.media);
    _index = widget.model.media.indexOf(widget.media);
    _badFile = widget.model.isBadFile(widget.media);

    if (_type == FileType.video) {
      _controller = VideoPlayerController.file(widget.media)
        ..initialize().then((_) => setState(() {}));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final length = widget.model.media.length;

    final decoration = _badFile
        ? BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              width: 3,
              color: Colors.red,
            ),
          )
        : null;

    final child = _type == FileType.video ? _buildVideo() : _buildImage();

    return Padding(
      padding: EdgeInsets.only(right: _index < length - 1 ? 8 : 0),
      child: Stack(
        children: <Widget>[
          Container(
            decoration: decoration,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: child,
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
                    onTap: () => widget.model.removeMedia(_index),
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
  }
}
