import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';
import 'package:rby/rby.dart';

class ComposeTweetActions extends ConsumerWidget {
  const ComposeTweetActions({
    required this.controller,
    required this.focusNode,
  });

  final ComposeTextController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(composeProvider.notifier);

    return Row(
      children: [
        RbyButton.transparent(
          icon: const Icon(CupertinoIcons.photo),
          onTap: notifier.pickMedia,
        ),
        HorizontalSpacer.small,
        RbyButton.transparent(
          icon: const Icon(CupertinoIcons.at),
          onTap: () {
            HapticFeedback.lightImpact();
            controller.insertString('@');
            focusNode.requestFocus();
          },
        ),
        HorizontalSpacer.small,
        RbyButton.transparent(
          label: const Text('#'),
          onTap: () {
            HapticFeedback.lightImpact();
            controller.insertString('#');
            focusNode.requestFocus();
          },
        ),
        const Spacer(),
        ComposeMaxLength(controller: controller),
        HorizontalSpacer.small,
        _PostTweetButton(controller: controller),
      ],
    );
  }
}

class _PostTweetButton extends ConsumerStatefulWidget {
  const _PostTweetButton({
    required this.controller,
  });

  final ComposeTextController controller;

  @override
  _PostTweetButtonState createState() => _PostTweetButtonState();
}

class _PostTweetButtonState extends ConsumerState<_PostTweetButton> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    super.dispose();

    widget.controller.removeListener(_listener);
  }

  void _listener() {
    if (mounted) setState(() {});
  }

  Future<void> _showDialog(ComposeState state) async {
    FocusScope.of(context).unfocus();

    final sentTweet = await showDialog<LegacyTweetData>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PostTweetDialog(
        text: widget.controller.text,
        attachmentUrl: state.quotedTweet?.tweetUrl,
        inReplyToStatusId: state.parentTweet?.id,
        media: state.media,
        mediaType: state.type,
      ),
    );

    if (sentTweet != null) {
      ref.read(homeTimelineProvider.notifier).addTweet(sentTweet);

      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(composeProvider);

    final canTweet = state.hasMedia || widget.controller.text.trim().isNotEmpty;

    return RbyButton.transparent(
      icon: const Icon(Icons.send),
      onTap: canTweet ? () => _showDialog(state) : null,
    );
  }
}
