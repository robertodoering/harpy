import 'package:flutter/material.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/widgets/overlay/overlay_action_row.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';

class MediaOverlay extends StatelessWidget {
  const MediaOverlay({
    @required this.tweet,
    @required this.tweetBloc,
    @required this.child,
  });

  final TweetData tweet;
  final TweetBloc tweetBloc;
  final Widget child;

  Widget _buildAppBar() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Colors.black87,
            Colors.transparent,
          ],
        ),
      ),
      child: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Colors.black87,
            Colors.transparent,
          ],
        ),
      ),
      child: MediaOverlayActionRow(tweetBloc),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        SafeArea(
          // app bar handles top safe area
          top: false,
          child: Column(
            children: <Widget>[
              _buildAppBar(),
              const Spacer(),
              _buildActions(),
            ],
          ),
        ),
      ],
    );
  }
}
