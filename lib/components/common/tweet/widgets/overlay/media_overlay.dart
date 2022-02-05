import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:harpy/misc/misc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

/// Default behavior to open a tweet media externally.
void defaultOnMediaOpenExternally(String? mediaUrl) {
  if (mediaUrl != null) {
    launchUrl(mediaUrl);
  }
}

/// Default behavior to download a tweet media.
///
/// Asks for generic storage permission if not already granted.
Future<void> defaultOnMediaDownload({
  required DownloadPathCubit downloadPathCubit,
  MediaType? type,
  String? url,
}) async {
  if (type != null && url != null) {
    final filename = filenameFromUrl(url);

    if (filename != null) {
      final notifier = ValueNotifier<DownloadStatus>(
        DownloadStatus(
          message: 'downloading ${type.name}...',
          state: DownloadState.inProgress,
        ),
      );

      final storagePermission = await Permission.storage.request();

      if (!storagePermission.isGranted) {
        app<MessageService>().show('storage permission not granted');
        return;
      }

      DownloadDialogSelection? selection;

      if (app<MediaPreferences>().showDownloadDialog) {
        selection = await showDialog<DownloadDialogSelection>(
          context: app<HarpyNavigator>().state.context,
          builder: (_) => BlocProvider.value(
            value: downloadPathCubit,
            child: DownloadDialog(initialName: filename, type: type),
          ),
        );
      } else {
        selection = DownloadDialogSelection(
          name: filename,
          path: downloadPathCubit.state.fullPathForType(type) ?? '',
        );
      }

      if (selection == null) {
        return;
      }

      app<MessageService>().showCustom(
        SnackBar(
          content: DownloadStatusMessage(notifier: notifier),
          duration: const Duration(seconds: 15),
        ),
      );

      await app<DownloadService>()
          .download(
            url: url,
            name: selection.name,
            path: selection.path,
            onSuccess: (path) => notifier.value = DownloadStatus(
              message: '${type.name} saved in\n$path',
              state: DownloadState.successful,
            ),
            onFailure: () => notifier.value = const DownloadStatus(
              message: 'download failed',
              state: DownloadState.failed,
            ),
          )
          .handleError(silentErrorHandler);

      // hide snack bar shortly after download finished (assuming it's
      // still showing)
      await Future<void>.delayed(const Duration(seconds: 4));
      app<MessageService>().messageState.state.hideCurrentSnackBar();
    }
  }
}

/// Default behavior to share a tweet media.
void defaultOnMediaShare(String? mediaUrl) {
  if (mediaUrl != null) {
    Share.share(mediaUrl);
  }
}

class MediaOverlay extends StatefulWidget {
  const MediaOverlay({
    required this.child,
    required this.onDownload,
    required this.onOpenExternally,
    required this.onShare,
    this.enableImmersiveMode = true,
    this.enableDismissible = true,
    this.overlap = false,
    this.onShowTweet,
  });

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
  final VoidCallback? onShowTweet;

  /// Pushes the [MediaOverlay] with a [HeroDialogRoute].
  ///
  /// When no [onDownload], [onOpenExternally] and [onShare] callbacks are
  /// provided, the default implementations will be used.
  static void open({
    required TweetBloc tweetBloc,
    required Widget child,
    bool enableImmersiveMode = true,
    bool enableDismissible = true,
    bool overlap = false,
    VoidCallback? onDownload,
    VoidCallback? onOpenExternally,
    VoidCallback? onShare,
  }) {
    final tweet = tweetBloc.tweet;

    final mediaUrl = tweet.downloadMediaUrl();

    app<HarpyNavigator>().push(
      HeroDialogRoute<void>(
        onBackgroundTap: app<HarpyNavigator>().maybePop,
        builder: (context) => BlocProvider.value(
          value: tweetBloc,
          child: MediaOverlay(
            enableImmersiveMode: enableImmersiveMode,
            enableDismissible: enableDismissible,
            overlap: overlap,
            onDownload: onDownload ??
                () => defaultOnMediaDownload(
                      downloadPathCubit: context.read(),
                      type: tweet.mediaType,
                      url: mediaUrl,
                    ),
            onOpenExternally: onOpenExternally ??
                () => defaultOnMediaOpenExternally(mediaUrl),
            onShare: onShare ?? () => defaultOnMediaShare(mediaUrl),
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  _MediaOverlayState createState() => _MediaOverlayState();
}

class _MediaOverlayState extends State<MediaOverlay>
    with SingleTickerProviderStateMixin<MediaOverlay>, RouteAware {
  late AnimationController _controller;
  late Animation<Offset> _topAnimation;
  late Animation<Offset> _bottomAnimation;

  late TweetMediaModel _model;

  @override
  void initState() {
    super.initState();

    _model = TweetMediaModel();

    _controller = AnimationController(
      vsync: this,
      duration: kShortAnimationDuration,
    );

    _topAnimation = Tween(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _bottomAnimation = Tween(
      begin: Offset.zero,
      end: const Offset(0, 1),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.reverse(from: 1);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    harpyRouteObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    harpyRouteObserver.unsubscribe(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didPop() {
    _model.resetOverlays();
    _controller.forward();
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
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black87,
            Colors.transparent,
          ],
        ),
      ),
      child: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: const HarpyBackButton(color: Colors.white),
      ),
    );
  }

  Widget _buildActions() {
    final mediaQuery = MediaQuery.of(context);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black87,
          ],
        ),
      ),
      padding: EdgeInsets.only(bottom: mediaQuery.padding.bottom),
      child: MediaOverlayActionRow(
        onDownload: widget.onDownload,
        onOpenExternally: widget.onOpenExternally,
        onShare: widget.onShare,
        onShowTweet: widget.onShowTweet,
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
        onDismissed: app<HarpyNavigator>().maybePop,
        child: child,
      );
    }

    return child;
  }

  Widget _buildOverlappingOverlay() {
    return Stack(
      children: [
        _buildMedia(),
        AnimatedBuilder(
          animation: _controller,
          builder: (_, __) => Column(
            children: [
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
      builder: (_, __) => Column(
        children: [
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
    return widget.overlap ? _buildOverlappingOverlay() : _buildOverlay();
  }
}
