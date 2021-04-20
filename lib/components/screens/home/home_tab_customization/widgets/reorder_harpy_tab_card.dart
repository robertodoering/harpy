import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_tab/harpy_tab.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class ReorderHarpyTabCard extends StatefulWidget {
  ReorderHarpyTabCard({
    @required this.entry,
    @required this.index,
    @required this.onToggleVisibility,
    @required this.onRemove,
  }) : super(key: ValueKey<String>(entry.id));

  final HomeTabEntry entry;
  final int index;
  final VoidCallback onToggleVisibility;
  final VoidCallback onRemove;

  @override
  _ReorderHarpyTabCardState createState() => _ReorderHarpyTabCardState();
}

class _ReorderHarpyTabCardState extends State<ReorderHarpyTabCard> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.entry.name);
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  Widget _buildEntryIcon(ThemeData theme) {
    IconData iconData;

    // todo: map icon name to icon data

    if (widget.entry.icon == 'home') {
      iconData = CupertinoIcons.home;
    } else if (widget.entry.icon == 'media') {
      iconData = CupertinoIcons.photo;
    } else if (widget.entry.icon == 'search') {
      iconData = CupertinoIcons.search;
    }

    if (iconData != null) {
      return Icon(
        iconData,
        size: HarpyTab.tabIconSize,
      );
    } else {
      return Text(
        widget.entry.icon,
        style: theme.textTheme.subtitle1,
      );
    }
  }

  Widget _buildTextField(ThemeData theme) {
    return TextField(
      controller: _controller,
      scrollPadding: EdgeInsets.zero,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.zero,
        isDense: true,
      ),
      style: theme.textTheme.subtitle1,
      // decoration: InputDecoration(),
    );
  }

  Widget _buildToggleVisibilityIcon() {
    return HarpyButton.flat(
      padding: const EdgeInsets.all(HarpyTab.tabPadding)
          .copyWith(right: HarpyTab.tabPadding / 2),
      icon: Icon(
        widget.entry.visible ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
        size: HarpyTab.tabIconSize,
      ),
      onTap: widget.onToggleVisibility,
    );
  }

  Widget _buildRemoveEntryIcon() {
    return HarpyButton.flat(
      padding: const EdgeInsets.all(HarpyTab.tabPadding)
          .copyWith(right: HarpyTab.tabPadding / 2),
      icon: const Icon(
        CupertinoIcons.xmark,
        size: HarpyTab.tabIconSize,
      ),
      onTap: widget.onRemove,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return AnimatedOpacity(
      duration: kShortAnimationDuration,
      opacity: widget.entry.visible ? 1 : .6,
      child: Card(
        margin: EdgeInsets.only(bottom: defaultSmallPaddingValue),
        child: Row(
          children: <Widget>[
            HarpyButton.flat(
              padding: const EdgeInsets.all(HarpyTab.tabPadding),
              icon: _buildEntryIcon(theme),
              onTap: () {}, // todo: open change icon dialog
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: HarpyTab.tabPadding,
                ),
                child: _buildTextField(theme),
              ),
            ),
            if (widget.entry.deletable)
              _buildRemoveEntryIcon()
            else
              _buildToggleVisibilityIcon(),
            ReorderableDragStartListener(
              index: widget.index,
              child: Container(
                padding: const EdgeInsets.all(HarpyTab.tabPadding)
                    .copyWith(left: HarpyTab.tabPadding / 2),
                color: Colors.transparent,
                child: const Icon(
                  CupertinoIcons.bars,
                  size: HarpyTab.tabIconSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
