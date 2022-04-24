import 'package:harpy/components/components.dart';

const timelineFilter1 = TimelineFilter(
  uuid: '1337',
  name: 'poi',
  includes: TimelineFilterIncludes(
    image: false,
    gif: false,
    video: false,
    phrases: [],
    hashtags: [],
    mentions: [],
  ),
  excludes: TimelineFilterExcludes(
    replies: false,
    retweets: false,
    phrases: [],
    hashtags: [],
    mentions: [],
  ),
);

const timelineFilter2 = TimelineFilter(
  uuid: '1338',
  name: 'wow',
  includes: TimelineFilterIncludes(
    image: false,
    gif: false,
    video: false,
    phrases: [],
    hashtags: [],
    mentions: [],
  ),
  excludes: TimelineFilterExcludes(
    replies: false,
    retweets: true,
    phrases: [
      'ad',
      'ads',
      'sponsored',
    ],
    hashtags: [],
    mentions: [],
  ),
);

const activeHomeTimelineFilter1 = ActiveTimelineFilter(
  uuid: '1337',
  type: TimelineFilterType.home,
);

const activeHomeTimelineFilter2 = ActiveTimelineFilter(
  uuid: '1338',
  type: TimelineFilterType.home,
);

const activeGenericUserTimelineFilter2 = ActiveTimelineFilter(
  uuid: '1338',
  type: TimelineFilterType.user,
);

const activeSpecificUserTimelineFilter1 = ActiveTimelineFilter(
  uuid: '1337',
  type: TimelineFilterType.user,
  data: TimelineFilterData.user(handle: 'harpy_app', id: '69'),
);

const activeGenericListTimelineFilter2 = ActiveTimelineFilter(
  uuid: '1338',
  type: TimelineFilterType.list,
);

const activeSpecificListTimelineFilter2 = ActiveTimelineFilter(
  uuid: '1338',
  type: TimelineFilterType.list,
  data: TimelineFilterData.list(name: 'Flutter', id: '42'),
);

const activeSpecificListTimelineFilter3 = ActiveTimelineFilter(
  uuid: '1338',
  type: TimelineFilterType.list,
  data: TimelineFilterData.list(name: 'Untitled List', id: '666'),
);
