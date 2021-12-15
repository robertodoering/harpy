import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class TweetCardQuote extends StatefulWidget {
  const TweetCardQuote();

  @override
  _TweetCardQuoteState createState() => _TweetCardQuoteState();
}

class _TweetCardQuoteState extends State<TweetCardQuote> {
  late TweetBloc _bloc;
  late TweetBloc _parentBloc;

  late Locale _locale;

  @override
  void initState() {
    super.initState();

    _parentBloc = context.read<TweetBloc>();
    assert(_parentBloc.tweet.quote != null);

    _bloc = TweetBloc(_parentBloc.tweet.quote!);

    _parentBloc.addCallback(_onParentTweetAction);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _locale = Localizations.localeOf(context);
  }

  @override
  void dispose() {
    _parentBloc.removeCallback(_onParentTweetAction);
    _bloc.close();

    super.dispose();
  }

  void _onParentTweetAction(TweetAction action) {
    if (mounted) {
      switch (action) {
        case TweetAction.translate:
          _bloc.onTranslate(_locale);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: const _TweetCardQuoteBase(),
    );
  }
}

class _TweetCardQuoteBase extends StatelessWidget {
  const _TweetCardQuoteBase();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    final bloc = context.watch<TweetBloc>();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: bloc.onTweetTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: kBorderRadius,
          border: Border.all(color: theme.dividerColor),
        ),
        child: TweetCardContent(
          outerPadding: config.smallPaddingValue,
          innerPadding: config.smallPaddingValue / 2,
          config: kDefaultTweetCardQuoteConfig,
        ),
      ),
    );
  }
}
