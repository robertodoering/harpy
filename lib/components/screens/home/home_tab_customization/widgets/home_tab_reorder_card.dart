import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_tab/harpy_tab.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class HomeTabReorderCard extends StatefulWidget {
  HomeTabReorderCard({
    @required this.index,
    @required this.model,
  }) : super(key: ValueKey<String>(model.value.entries[index].id));

  final int index;
  final HomeTabModel model;

  @override
  _HomeTabReorderCardState createState() => _HomeTabReorderCardState();
}

class _HomeTabReorderCardState extends State<HomeTabReorderCard> {
  TextEditingController _controller;

  HomeTabEntry get _entry => widget.model.value.entries[widget.index];

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: _entry.name);
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
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
      onChanged: (String value) => widget.model.changeName(
        widget.index,
        value,
      ),
    );
  }

  Widget _buildToggleVisibilityIcon() {
    return HarpyButton.flat(
      padding: const EdgeInsets.all(HarpyTab.tabPadding)
          .copyWith(right: HarpyTab.tabPadding / 2),
      icon: Icon(
        _entry.visible ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
        size: HarpyTab.tabIconSize,
      ),
      // prevent hiding the last entry
      onTap: !widget.model.canHideMoreEntries && _entry.visible
          ? null
          : () {
              HapticFeedback.lightImpact();
              widget.model.toggleVisible(widget.index);
            },
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
      onTap: () {
        HapticFeedback.lightImpact();
        widget.model.remove(widget.index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return AnimatedOpacity(
      duration: kShortAnimationDuration,
      opacity: _entry.visible ? 1 : .6,
      child: Card(
        margin: EdgeInsets.only(bottom: defaultSmallPaddingValue),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(HarpyTab.tabPadding / 2),
              child: HarpyButton.raised(
                padding: const EdgeInsets.all(HarpyTab.tabPadding / 2),
                icon: HomeTabEntryIcon(
                  _entry.icon,
                  size: HarpyTab.tabIconSize,
                ),
                onTap: () async {
                  widget.model.changeIcon(
                    widget.index,
                    await showDialog<String>(
                      context: context,
                      builder: (_) => ChangeHomeTabEntryIconDialog(
                        entry: _entry,
                      ),
                    ).then((String value) {
                      if (value != null && value.isNotEmpty) {
                        HapticFeedback.lightImpact();
                      }

                      return value;
                    }),
                  );
                },
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: HarpyTab.tabPadding,
                ),
                child: _buildTextField(theme),
              ),
            ),
            if (_entry.removable)
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
