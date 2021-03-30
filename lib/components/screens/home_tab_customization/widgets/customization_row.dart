import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/harpy_widgets/harpy_widgets.dart';

class CustomizationRow extends StatelessWidget {
  const CustomizationRow({
    @required this.index,
    @required this.icon,
    Key key,
  }) : super(key: key);

  final int index;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: DefaultEdgeInsets.only(bottom: true),
      child: Row(
        children: <Widget>[
          HarpyButton.flat(
            padding: const EdgeInsets.all(16),
            icon: icon,
            iconSize: 20,
            style: const TextStyle(fontSize: 20),
            onTap: () {},
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: TextField(),
            ),
          ),
          ReorderableDragStartListener(
            // wrap in container to have the drag start listener catch
            // gestures on transparency
            index: index,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.transparent,
              child: const Icon(CupertinoIcons.bars),
            ),
          ),
        ],
      ),
    );
  }
}
