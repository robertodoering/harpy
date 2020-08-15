import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/common/misc/flare_icons.dart';

/// Builds a [HarpyButton] to favorite / unfavorite a tweet.
///
/// Uses the animated [FlareIcon.favorite] icon.
class FavoriteButton extends StatefulWidget {
  const FavoriteButton({
    @required this.favorited,
    @required this.text,
    @required this.favorite,
    @required this.unfavorite,
    this.padding = const EdgeInsets.all(8),
  });

  /// Whether the button appears in its favorite state.
  final bool favorited;

  /// The text next to the [FlareIcon.favorite].
  final String text;

  /// The padding for the button.
  final EdgeInsets padding;

  /// Called when the button is pressed and [favorited] is `false`.
  final VoidCallback favorite;

  /// Called when the button is pressed and [favorited] is `true`.
  final VoidCallback unfavorite;

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  static const String _favorite = 'favorite';
  static const String _favoriteStatic = 'favoriteStatic';
  static const String _unfavorite = 'unfavorite';

  String _animation;

  Color get _color => widget.favorited ? Colors.red : null;

  @override
  void initState() {
    super.initState();

    _animation = widget.favorited ? _favoriteStatic : _unfavorite;
  }

  @override
  void didUpdateWidget(FavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.favorited && _animation == _unfavorite) {
      _animation = _favorite;
    } else if (widget.favorited) {
      _animation = _favoriteStatic;
    } else if (!widget.favorited) {
      _animation = _unfavorite;
    }
  }

  Widget _iconBuilder(ThemeData theme) {
    final Color color = _color ?? theme.iconTheme.color;

    return FlareIcon.favorite(animation: _animation, color: color);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return HarpyButton.flat(
      text: widget.text,
      iconBuilder: (BuildContext context) => _iconBuilder(theme),
      foregroundColor: _color,
      onTap: widget.favorited ? widget.unfavorite : widget.favorite,
      padding: widget.padding,
    );
  }
}
