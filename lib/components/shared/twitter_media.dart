import 'package:flutter/material.dart';
import 'package:harpy/api/twitter/data/twitter_media.dart';

// media types
const String photo = "photo";
const String video = "video";
const String animatedGif = "animated_gif";

/// Builds a column of media that can be collapsed.
class CollapsibleMedia extends StatelessWidget {
  final List<TwitterMedia> media;

  const CollapsibleMedia(this.media);

  @override
  Widget build(BuildContext context) {
    print(media);

    return ExpansionTile(
      title: Container(),
      initiallyExpanded: true,
      children: <Widget>[
        Container(
          height: 250.0,
          child: _buildMedia(),
        ),
      ],
    );
  }

  Widget _buildMedia() {
    double padding = 2.0;

    if (media.length == 1) {
      return Row(
        children: <Widget>[
          _createMediaWidget(media[0]),
        ],
      );
    } else if (media.length == 2) {
      return Row(
        children: <Widget>[
          _createMediaWidget(media[0]),
          SizedBox(width: padding),
          _createMediaWidget(media[1]),
        ],
      );
    } else if (media.length == 3) {
      return Row(
        children: <Widget>[
          _createMediaWidget(media[0]),
          SizedBox(width: padding),
          Expanded(
            child: Column(
              children: <Widget>[
                _createMediaWidget(media[1]),
                SizedBox(height: padding),
                _createMediaWidget(media[2]),
              ],
            ),
          ),
        ],
      );
    } else if (media.length == 4) {
      return Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                _createMediaWidget(media[0]),
                SizedBox(height: padding),
                _createMediaWidget(media[2]),
              ],
            ),
          ),
          SizedBox(width: padding),
          Expanded(
            child: Column(
              children: <Widget>[
                _createMediaWidget(media[1]),
                SizedBox(height: padding),
                _createMediaWidget(media[3]),
              ],
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _createMediaWidget(TwitterMedia media) {
    if (media.type == photo) {
      return Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          child: Image.network(
            media.mediaUrl,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
