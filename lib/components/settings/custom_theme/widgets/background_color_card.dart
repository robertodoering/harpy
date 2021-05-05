import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

/// Builds a colored card for the background color selection of the
/// [CustomThemeBloc].
class BackgroundColorCard extends StatelessWidget {
  BackgroundColorCard({
    required this.bloc,
    required this.color,
    required this.index,
  }) : super(key: ValueKey<int>(hashValues(color, index)));

  final CustomThemeBloc bloc;
  final Color? color;
  final int index;

  Future<void> _changeBackgroundColor(BuildContext context) async {
    final Color? newColor = await showDialog<Color>(
      context: context,
      builder: (BuildContext context) => ColorPickerDialog(
        color: color,
      ),
    );

    if (newColor != null) {
      bloc.add(ChangeBackgroundColor(index: index, color: newColor));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Color textColor =
        ThemeData.estimateBrightnessForColor(color!) == Brightness.light
            ? Colors.black
            : Colors.white;

    return Theme(
      data: theme.copyWith(
        textTheme: theme.textTheme.apply(bodyColor: textColor),
        iconTheme: theme.iconTheme.copyWith(color: textColor),
      ),
      child: Card(
        margin: EdgeInsets.only(
          left: defaultPaddingValue,
          right: defaultPaddingValue,
          bottom: defaultPaddingValue / 2,
        ),
        color: color,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: <Widget>[
            ListTile(
              leading: const SizedBox(),
              trailing: const SizedBox(),
              shape: kDefaultShapeBorder,
              onTap: () => _changeBackgroundColor(context),
            ),
            HarpyButton.flat(
              icon: const Icon(CupertinoIcons.xmark, size: 20),
              padding: const EdgeInsets.all(16),
              onTap: bloc.canRemoveBackgroundColor
                  ? () => bloc.add(RemoveBackgroundColor(index: index))
                  : null,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ReorderableDragStartListener(
                // wrap in container to have the drag start listener catch
                // gestures on transparency
                index: index,
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(16),
                  child: const Icon(CupertinoIcons.bars),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
