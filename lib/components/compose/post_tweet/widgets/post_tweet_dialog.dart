import 'package:built_collection/built_collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';

/// A dialog that uses the [PostTweetNotifier] to post a tweet.
///
/// While posting the tweet is in progress, the dialog is not dismissible.
class PostTweetDialog extends ConsumerStatefulWidget {
  const PostTweetDialog({
    required this.text,
    this.attachmentUrl,
    this.inReplyToStatusId,
    this.media,
    this.mediaType,
  });

  final String text;

  /// The tweet hyperlink of the quoted tweet if this tweet is a quote.
  final String? attachmentUrl;

  /// The id of the parent tweet if this tweet is a reply.
  final String? inReplyToStatusId;

  final BuiltList<PlatformFile>? media;
  final MediaType? mediaType;

  @override
  _PostTweetDialogState createState() => _PostTweetDialogState();
}

class _PostTweetDialogState extends ConsumerState<PostTweetDialog> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      ref.read(postTweetProvider.notifier).post(
            widget.text,
            attachmentUrl: widget.attachmentUrl,
            inReplyToStatusId: widget.inReplyToStatusId,
            media: widget.media,
            mediaType: widget.mediaType,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final display = ref.watch(displayPreferencesProvider);
    final state = ref.watch(postTweetProvider);

    return _WillPopDialog(
      state: state,
      child: HarpyDialog(
        title: const Text('tweeting'),
        content: AnimatedSize(
          duration: kShortAnimationDuration,
          curve: Curves.easeOutCubic,
          child: Column(
            children: [
              if (state is PostTweetError) ...[
                const _ErrorIndicator(),
                verticalSpacer,
              ],
              if (state.message != null) _StateMessage(state: state),
              if (state is PostTweetInProgress) ...[
                SizedBox(height: display.paddingValue * 2),
                const Center(child: CircularProgressIndicator()),
              ],
            ],
          ),
        ),
        actions: [
          HarpyButton.text(
            label: const Text('ok'),
            // need to use `maybePop` to trigger the `WillPopScope`
            onTap: state is PostTweetInProgress
                ? null
                : Navigator.of(context).maybePop,
          ),
        ],
      ),
    );
  }
}

class _ErrorIndicator extends StatelessWidget {
  const _ErrorIndicator();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.warning_rounded, color: theme.colorScheme.error),
        horizontalSpacer,
        const Flexible(
          child: Text(
            'error while tweeting',
            style: TextStyle(height: 1),
          ),
        ),
      ],
    );
  }
}

class _StateMessage extends StatelessWidget {
  const _StateMessage({
    required this.state,
  });

  final PostTweetState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return HarpyAnimatedSwitcher(
      duration: kShortAnimationDuration ~/ 2,
      child: Column(
        children: [
          Text(
            state.message!,
            key: Key(state.message!),
            textAlign: TextAlign.center,
          ),
          if (state.additionalInfo != null) ...[
            smallVerticalSpacer,
            Text(
              state.additionalInfo!,
              style: theme.textTheme.bodyText1,
            ),
          ],
        ],
      ),
    );
  }
}

class _WillPopDialog extends StatelessWidget {
  const _WillPopDialog({
    required this.child,
    required this.state,
  });

  final Widget child;
  final PostTweetState state;

  Future<bool> _onWillPop(BuildContext context) async {
    if (state is! PostTweetInProgress) {
      Navigator.of(context).pop(state.tweet);
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: child,
    );
  }
}
