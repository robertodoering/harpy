import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/widgets/shared/buttons.dart';
import 'package:harpy/models/theme_model.dart';

/// The [FavoriteIcon] for the [FavoriteButton] that uses a [FlareActor] to
/// build an animated icon for favoring a tweet.
class FavoriteIcon extends StatefulWidget {
  const FavoriteIcon({
    this.favorited = false,
    this.size = 18,
    this.color,
  });

  final bool favorited;
  final double size;
  final Color color;

  @override
  _FavoriteIconState createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  static const String favorite = "favorite";
  static const String favoriteStatic = "favoriteStatic";
  static const String unfavorite = "unfavorite";

  /// With the sizeDifference the flare animated icon will approx. be the same
  /// size as a material Icon.
  static const double sizeDifference = -0.5;

  String animation;

  @override
  void initState() {
    super.initState();

    animation = widget.favorited ? favoriteStatic : unfavorite;
  }

  @override
  void didUpdateWidget(FavoriteIcon oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.favorited && animation == unfavorite) {
      animation = favorite;
    } else if (!widget.favorited) {
      animation = unfavorite;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size + sizeDifference,
      height: widget.size + sizeDifference,
      child: FlareActor(
        "assets/flare/favorite.flr",
        animation: animation,
        color: widget.color,
      ),
    );
  }
}

/// Builds the [FavoriteButton] to favorite / unfavorite a tweet.
///
/// Uses the animated [FavoriteIcon].
class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    @required this.favorited,
    @required this.text,
    @required this.favorite,
    @required this.unfavorite,
  });

  /// Whether or not the tweet is already favorited.
  final bool favorited;

  /// The text next to the [FavoriteIcon].
  final String text;

  /// Called when the button is pressed and [favorited] is `false`.
  final VoidCallback favorite;

  /// Called when the button is pressed and [favorited] is `true`.
  final VoidCallback unfavorite;

  /// Builds the [FavoriteIcon].
  ///
  /// If [favorited] is `true` or the button is being [highlighted] the
  /// icon will appear in the like color of the theme.
  /// Otherwise it will be drawn in the default icon color.
  Widget _iconBuilder(BuildContext context, bool highlighted) {
    final Color iconColor = favorited || highlighted
        ? ThemeModel.of(context).harpyTheme.likeColor
        : Theme.of(context).iconTheme.color;

    return FavoriteIcon(favorited: favorited, color: iconColor);
  }

  @override
  Widget build(BuildContext context) {
    final Color likeColor = ThemeModel.of(context).harpyTheme.likeColor;

    return FlatHarpyButton(
      iconBuilder: _iconBuilder,
      text: text,
      color: likeColor,
      alwaysColored: favorited,
      onTap: favorited ? unfavorite : favorite,
    );
  }
}
