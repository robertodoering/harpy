import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/buttons.dart';
import 'package:harpy/components/widgets/shared/flare_icons.dart';

/// Builds the [FavoriteButton] to favorite / unfavorite a tweet.
///
/// Uses an animated [FlareIcon.favorite].
class FavoriteButton extends StatefulWidget {
  const FavoriteButton({
    @required this.favorited,
    @required this.text,
    @required this.favorite,
    @required this.unfavorite,
  });

  /// Whether or not the button appears in its favorite state.
  final bool favorited;

  /// The text next to the [FavoriteIcon].
  final String text;

  /// Called when the button is pressed and [favorited] is `false`.
  final VoidCallback favorite;

  /// Called when the button is pressed and [favorited] is `true`.
  final VoidCallback unfavorite;

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  static const String favorite = "favorite";
  static const String favoriteStatic = "favoriteStatic";
  static const String unfavorite = "unfavorite";

  String _animation;

  @override
  void initState() {
    super.initState();

    _animation = widget.favorited ? favoriteStatic : unfavorite;
  }

  @override
  void didUpdateWidget(FavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.favorited && _animation == unfavorite) {
      _animation = favorite;
    } else if (widget.favorited) {
      _animation = favoriteStatic;
    } else if (!widget.favorited) {
      _animation = unfavorite;
    }
  }

  /// Builds the [FlareIcon.favorite].
  ///
  /// If [widget.favorite] is `true` or the button is being [highlighted] the
  /// icon will appear in the like color of the theme.
  /// Otherwise it will be drawn in the default icon color.
  Widget _iconBuilder(BuildContext context, bool highlighted) {
    final Color iconColor = widget.favorited || highlighted
        ? Colors.red
        : Theme.of(context).iconTheme.color;

    return FlareIcon.favorite(
      animation: _animation,
      color: iconColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlatHarpyButton(
      iconBuilder: _iconBuilder,
      text: widget.text,
      color: Colors.red,
      alwaysColored: widget.favorited,
      onTap: widget.favorited ? widget.unfavorite : widget.favorite,
    );
  }
}
