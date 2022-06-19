import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/components/components.dart';

/// Provides the [TrendsLocationData] that is saved in the preferences.
final userTrendsLocationProvider = Provider(
  (ref) {
    final trendsLocationsPreferences = ref.watch(
      trendsLocationPreferencesProvider,
    );

    final jsonString = trendsLocationsPreferences.trendsLocationData;

    if (jsonString.isNotEmpty) {
      try {
        return TrendsLocationData.fromJson(
          jsonDecode(jsonString) as Map<String, dynamic>,
        );
      } catch (e) {
        // ignore
      }
    }

    return TrendsLocationData.worldwide();
  },
  name: 'CustomTrendsLocationProvider',
);
