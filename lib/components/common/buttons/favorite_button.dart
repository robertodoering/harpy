import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/common/misc/flare_icons.dart';
import 'package:harpy/core/theme/harpy_theme.dart';

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

  Widget _iconBuilder(ThemeData theme, HarpyTheme harpyTheme) {
    final Color color =
        widget.favorited ? harpyTheme.likeColor : theme.iconTheme.color;

    return FlareIcon.favorite(
      animation: _animation,
      color: color,
      // force rebuild when color changes since the flare actor doesn't
      // automatically update itself on color change
      key: UniqueKey(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final HarpyTheme harpyTheme = HarpyTheme.of(context);

    return HarpyButton.flat(
      text: Text(widget.text),
      icon: _iconBuilder(theme, harpyTheme),
      foregroundColor: widget.favorited ? harpyTheme.likeColor : null,
      onTap: widget.favorited ? widget.unfavorite : widget.favorite,
      padding: widget.padding,
    );
  }
}
