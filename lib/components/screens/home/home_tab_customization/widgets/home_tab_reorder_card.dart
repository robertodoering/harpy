import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';
import 'package:provider/provider.dart';

class HomeTabReorderCard extends StatefulWidget {
  HomeTabReorderCard({
    required this.index,
    required this.model,
  }) : super(key: ValueKey<String?>(model.value.entries[index].id));

  final int index;
  final HomeTabModel model;

  @override
  _HomeTabReorderCardState createState() => _HomeTabReorderCardState();
}

class _HomeTabReorderCardState extends State<HomeTabReorderCard> {
  TextEditingController? _controller;

  HomeTabEntry get _entry => widget.model.value.entries[widget.index];

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: _entry.name);
  }

  @override
  void dispose() {
    super.dispose();

    _controller!.dispose();
  }

  Widget _buildTextField(ThemeData theme) {
    return TextField(
      controller: _controller,
      scrollPadding: EdgeInsets.zero,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        isDense: true,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.dividerColor),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.dividerColor),
        ),
      ),
      style: theme.textTheme.subtitle1,
      onChanged: (value) => widget.model.changeName(
        widget.index,
        value,
      ),
    );
  }

  Widget _buildToggleVisibilityIcon(double tabPadding) {
    return HarpyButton.flat(
      padding: EdgeInsets.all(tabPadding).copyWith(right: tabPadding / 2),
      icon: Icon(
        _entry.visible! ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
      ),
      // prevent hiding the last entry
      onTap: !widget.model.canHideMoreEntries && _entry.visible!
          ? null
          : () {
              HapticFeedback.lightImpact();
              widget.model.toggleVisible(widget.index);
            },
    );
  }

  Widget _buildRemoveEntryIcon(double tabPadding) {
    return HarpyButton.flat(
      padding: EdgeInsets.all(tabPadding).copyWith(right: tabPadding / 2),
      icon: const Icon(CupertinoIcons.xmark),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.model.remove(widget.index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = context.watch<ConfigCubit>().state;

    final tabPadding = HarpyTab.tabPadding(context);

    return AnimatedOpacity(
      duration: kShortAnimationDuration,
      opacity: _entry.visible! ? 1 : .6,
      child: Card(
        margin: EdgeInsets.only(bottom: config.smallPaddingValue),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(tabPadding / 2),
              child: HarpyButton.raised(
                padding: EdgeInsets.all(tabPadding / 2),
                icon: HomeTabEntryIcon(_entry.icon),
                onTap: () async {
                  widget.model.changeIcon(
                    widget.index,
                    await showDialog<String>(
                      context: context,
                      builder: (_) => ChangeHomeTabEntryIconDialog(
                        entry: _entry,
                      ),
                    ).then((value) {
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
                padding: EdgeInsets.symmetric(
                  vertical: tabPadding,
                  horizontal: config.smallPaddingValue,
                ),
                child: _buildTextField(theme),
              ),
            ),
            if (_entry.removable)
              _buildRemoveEntryIcon(tabPadding)
            else
              _buildToggleVisibilityIcon(tabPadding),
            ReorderableDragStartListener(
              index: widget.index,
              child: Container(
                padding: EdgeInsets.all(tabPadding).copyWith(
                  left: tabPadding / 2,
                ),
                color: Colors.transparent,
                child: const Icon(CupertinoIcons.bars),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
