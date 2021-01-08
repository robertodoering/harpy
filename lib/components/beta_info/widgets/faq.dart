import 'package:flutter/material.dart';
import 'package:harpy/components/beta_info/widgets/beta_info_screen.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/misc/url_launcher.dart';

class BetaFaq extends StatelessWidget {
  const BetaFaq({
    this.onEmailTap,
  });

  final VoidCallback onEmailTap;

  VoidCallback get launchGithubProject =>
      () => launchUrl('https://github.com/robertodoering/harpy/projects/1');

  VoidCallback get launchKofi =>
      () => launchUrl('https://ko-fi.com/robertodoering');

  List<_FaqEntry> _faqEntries(ThemeData theme) {
    return <_FaqEntry>[
      _FaqEntry(
        question: const Text.rich(
          TextSpan(
            children: <InlineSpan>[
              TextSpan(text: 'When will '),
              TextSpan(
                text: '(feature)',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              TextSpan(text: ' get released?'),
            ],
          ),
        ),
        answer: Text.rich(
          TextSpan(
            children: <InlineSpan>[
              const TextSpan(
                text: 'If you are interested in what features are being '
                    'worked on and what is coming soon, check out the ',
              ),
              WidgetSpan(
                child: LinkText(
                  text: 'GitHub project',
                  onTap: launchGithubProject,
                ),
              ),
              const TextSpan(
                text: '.\n\nIf you have a request that has not been added to '
                    'the project yet, let me know via ',
              ),
              WidgetSpan(child: LinkText(text: 'email', onTap: onEmailTap)),
              const TextSpan(text: '.'),
            ],
          ),
        ),
      ),
      _FaqEntry(
        question: const Text('How can I support the development of Harpy?'),
        answer: Text.rich(
          TextSpan(
            children: <InlineSpan>[
              const TextSpan(
                text: 'You can buy Harpy Pro when it comes out!\n\n'
                    'Additionally, you can support me by buying me a coffee ',
              ),
              WidgetSpan(child: LinkText(text: 'here', onTap: launchKofi)),
              const TextSpan(text: '.'),
            ],
          ),
        ),
      ),
      const _FaqEntry(
        question: Text('When will the pro version get released?'),
        answer: Text("After all 'essential' features are complete and Harpy is "
            'stable.'),
      ),
      const _FaqEntry(
        question: Text('Why is the development taking a while?'),
        answer: Text('I am working solo on Harpy in my limited free time.'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final List<_FaqEntry> entries = _faqEntries(theme);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (_FaqEntry entry in entries) ...<Widget>[
          ContentCard(children: <Widget>[entry]),
          if (entry != entries.last) defaultVerticalSpacer,
        ]
      ],
    );
  }
}

class _FaqEntry extends StatelessWidget {
  const _FaqEntry({
    @required this.question,
    @required this.answer,
  });

  final Text question;
  final Text answer;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DefaultTextStyle(style: theme.textTheme.subtitle2, child: question),
        defaultSmallVerticalSpacer,
        answer,
      ],
    );
  }
}
