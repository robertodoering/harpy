import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

// FIXME: refactor

class HarpyTab extends ConsumerStatefulWidget {
  const HarpyTab({
    required this.icon,
    this.text,
    this.cardColor,
    this.selectedCardColor,
    this.selectedForegroundColor,
  });

  final Widget icon;
  final Widget? text;

  final Color? cardColor;
  final Color? selectedCardColor;
  final Color? selectedForegroundColor;

  static double height(BuildContext context, DisplayPreferences display) {
    final iconSize = IconTheme.of(context).size!;

    return tabPadding(display) * 2 + iconSize;
  }

  static double tabPadding(DisplayPreferences display) {
    return display.paddingValue;
  }

  @override
  _HarpyTabState createState() => _HarpyTabState();
}

class _HarpyTabState extends ConsumerState<HarpyTab>
    with SingleTickerProviderStateMixin<HarpyTab> {
  /// Controls how much the tab's associated content is in view.
  ///
  /// 1: Tab content is fully in view and tab should appear selected.
  /// 0: Tab content is not visible.
  late AnimationController _animationController;

  late Animation<Color?> _foregroundColorAnimation;
  late Animation<Color?> _cardColorAnimation;
  late Animation<double> _textOpacityAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this)
      ..addListener(() => setState(() {}));

    _textOpacityAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, .5),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (HarpyTabScope.of(context) != null) {
      _animationController.value = HarpyTabScope.of(context)!.animationValue;
    }

    final theme = Theme.of(context);

    final cardColor = widget.cardColor ?? theme.cardTheme.color!;
    final selectedCardColor = widget.selectedCardColor ?? cardColor;

    _cardColorAnimation = ColorTween(
      begin: selectedCardColor,
      end: cardColor.withOpacity(cardColor.opacity * .8),
    ).animate(_animationController);

    _foregroundColorAnimation = ColorTween(
      begin: widget.selectedForegroundColor ?? theme.colorScheme.primary,
      end: theme.colorScheme.onBackground,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    super.dispose();

    _animationController.dispose();
  }

  Widget _buildText() {
    return Opacity(
      opacity: _textOpacityAnimation.value,
      child: Align(
        widthFactor: 1 - _animationController.value,
        alignment: Alignment.centerRight,
        child: Row(
          children: [
            smallHorizontalSpacer,
            widget.text!,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconTheme = IconTheme.of(context);
    final display = ref.watch(displayPreferencesProvider);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, __) => Card(
        color: _cardColorAnimation.value,
        child: Padding(
          padding: EdgeInsets.all(HarpyTab.tabPadding(display)),
          child: IconTheme(
            data: iconTheme.copyWith(
              color: _foregroundColorAnimation.value,
            ),
            child: DefaultTextStyle(
              style: theme.textTheme.subtitle1!.copyWith(
                color: _foregroundColorAnimation.value,
              ),
              child: SizedBox(
                height: iconTheme.size,
                child: Row(
                  children: [
                    widget.icon,
                    if (widget.text != null) _buildText(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
