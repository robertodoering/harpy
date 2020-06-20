import 'package:flutter/material.dart';
import 'package:harpy/components/common/scroll_direction_listener.dart';
import 'package:harpy/components/common/scroll_to_start.dart';

class TweetTimeline extends StatefulWidget {
  @override
  _TweetTimelineState createState() => _TweetTimelineState();
}

class _TweetTimelineState extends State<TweetTimeline> {
  @override
  Widget build(BuildContext context) {
    return TweetList();
  }
}

class TweetList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScrollDirectionListener(
      child: ScrollToStart(
        child: ListView.builder(
          itemCount: 30,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 50,
              alignment: Alignment.center,
              child: Text('child  $index'),
            );
          },
        ),
      ),
    );
  }
}
