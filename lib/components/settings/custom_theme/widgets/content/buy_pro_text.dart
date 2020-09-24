import 'package:flutter/material.dart';
import 'package:harpy/components/common/buttons/harpy_button.dart';
import 'package:harpy/components/common/misc/flare_icons.dart';
import 'package:harpy/components/settings/layout/widgets/layout_padding.dart';
import 'package:harpy/core/message_service.dart';
import 'package:harpy/core/service_locator.dart';

/// Builds a button linking to the pro version of Harpy.
class BuyProText extends StatelessWidget {
  const BuyProText();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: DefaultEdgeInsets.symmetric(horizontal: true),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const FlareIcon.shiningStar(size: 32),
          HarpyButton.flat(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            text: const Text('Buy Harpy Pro'),
            // todo: link to harpy pro
            // todo: analytics
            onTap: () => app<MessageService>().showInfo('Not yet available'),
          ),
        ],
      ),
    );
  }
}
