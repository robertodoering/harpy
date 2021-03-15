import 'package:flutter/material.dart';
import 'package:harpy/components/common/animations/animation_constants.dart';
import 'package:harpy/components/common/misc/custom_dismissible.dart';
import 'package:harpy/components/common/routes/hero_dialog_route.dart';
import 'package:harpy/components/tweet/bloc/tweet_bloc.dart';
import 'package:harpy/components/tweet/model/tweet_media_model.dart';
import 'package:harpy/components/tweet/widgets/overlay/overlay_action_row.dart';
import 'package:harpy/core/api/network_error_handler.dart';
import 'package:harpy/core/api/twitter/tweet_data.dart';
import 'package:harpy/core/download_service.dart';
import 'package:harpy/core/service_locator.dart';
import 'package:harpy/misc/harpy_navigator.dart';
import 'package:harpy/misc/url_launcher.dart';
import 'package:harpy/misc/utils/string_utils.dart';
import 'package:share/share.dart';

/// Default behaviour to open a tweet media externally.
void onOpenExternally(String mediaUrl) {
  if (mediaUrl != null) {
    launchUrl(mediaUrl);
  }
}

/// Default behaviour to download a tweet media.
void onDownload(String mediaUrl) {
  if (mediaUrl != null) {
    final DownloadService downloadService = app<DownloadService>();

    final String url = mediaUrl;
    final String fileName = fileNameFromUrl(url);

    if (url != null && fileName != null) {
      downloadService
          .download(url: url, name: fileName)
          .catchError(silentErrorHandler);
    }
  }
}

/// Default behaviour to share a tweet media.
void onShare(String mediaUrl) {
  if (mediaUrl != null) {
    Share.share(mediaUrl);
  }
}

// todo: use default functions in overlay and get media url with index from
//  tweet and remove tweet bloc events
class MediaOverlay extends StatefulWidget {
  const MediaOverlay({
    @required this.tweet,
    @required this.tweetBloc,
    @required this.child,
    this.enableImmersiveMode = true,
    this.enableDismissible = true,
    this.overlap = false,
    this.onDownload,
    this.onOpenExternally,
    this.onShare,
  });

  final TweetData tweet;
  final TweetBloc tweetBloc;
  final Widget child;

  /// When set to `true`, tapping the [child] will hide the overlay and disable
  /// the system ui.
  final bool enableImmersiveMode;

  /// Wraps the child in a [CustomDismissible] when set to `true`.
  final bool enableDismissible;

  /// Whether the overlay should overlap the [child].
  final bool overlap;

  final VoidCallback onDownload;
  final VoidCallback onOpenExternally;
  final VoidCallback onShare;

  /// Pushes the [MediaOverlay] with a [HeroDialogRoute].
  static void open({
    @required TweetData tweet,
    @required TweetBloc tweetBloc,
    @required Widget child,
    bool enableImmersiveMode = true,
    bool enableDismissible = true,
    bool overlap = false,
    VoidCallback onDownload,
    VoidCallback onOpenExternally,
    VoidCallback onShare,
  }) {
    app<HarpyNavigator>().pushRoute(
      HeroDialogRoute<void>(
        onBackgroundTap: () => app<HarpyNavigator>().state.maybePop(),
        builder: (BuildContext context) => MediaOverlay(
          tweet: tweet,
          tweetBloc: tweetBloc,
          enableImmersiveMode: enableImmersiveMode,
          enableDismissible: enableDismissible,
          overlap: overlap,
          onDownload: onDownload,
          onOpenExternally: onOpenExternally,
          onShare: onShare,
          child: child,
        ),
      ),
    );
  }

  @override
  _MediaOverlayState createState() => _MediaOverlayState();
}

class _MediaOverlayState extends State<MediaOverlay>
    with SingleTickerProviderStateMixin<MediaOverlay> {
  AnimationController _controller;
  Animation<Offset> _topAnimation;
  Animation<Offset> _bottomAnimation;

  TweetMediaModel _model;

  @override
  void initState() {
    super.initState();

    _model = TweetMediaModel();

    _controller = AnimationController(
      vsync: this,
      duration: kShortAnimationDuration,
    );

    _topAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _bottomAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.reverse(from: 1);
  }

  Future<bool> _onWillPop() async {
    _model.resetOverlays();
    _controller.forward();
    return true;
  }

  void _onMediaTap() {
    if (_model.showingOverlays) {
      _controller.forward(from: 0);
    } else {
      _controller.reverse(from: 1);
    }

    _model.toggleOverlays();
  }

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
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    );
  }

  Widget _buildActions() {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Colors.transparent,
            Colors.black87,
          ],
        ),
      ),
      padding: EdgeInsets.only(bottom: mediaQuery.padding.bottom),
      child: MediaOverlayActionRow(
        widget.tweetBloc,
        onDownload: widget.onDownload,
        onOpenExternally: widget.onOpenExternally,
        onShare: widget.onShare,
      ),
    );
  }

  Widget _buildMedia() {
    Widget child = Center(child: widget.child);

    if (widget.enableImmersiveMode) {
      child = GestureDetector(
        onTap: _onMediaTap,
        child: child,
      );
    }

    if (widget.enableDismissible) {
      child = CustomDismissible(
        onDismissed: () => app<HarpyNavigator>().state.maybePop(),
        child: child,
      );
    }

    return child;
  }

  Widget _buildOverlappingOverlay() {
    return Stack(
      children: <Widget>[
        _buildMedia(),
        AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget _) => Column(
            children: <Widget>[
              SlideTransition(
                position: _topAnimation,
                child: _buildAppBar(),
              ),
              const Spacer(),
              SlideTransition(
                position: _bottomAnimation,
                child: _buildActions(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverlay() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget _) => Column(
        children: <Widget>[
          SlideTransition(
            position: _topAnimation,
            child: _buildAppBar(),
          ),
          Expanded(child: _buildMedia()),
          SlideTransition(
            position: _bottomAnimation,
            child: _buildActions(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: widget.overlap ? _buildOverlappingOverlay() : _buildOverlay(),
    );
  }
}
