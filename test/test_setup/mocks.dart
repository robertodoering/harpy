import 'package:go_router/go_router.dart';
import 'package:harpy/components/components.dart';
import 'package:harpy/core/core.dart';
import 'package:mocktail/mocktail.dart';

class MockApplication extends Mock implements Application {}

class MockConnectivityService extends Mock implements ConnectivityService {
  MockConnectivityService() {
    when(initialize).thenAnswer((_) async {});
  }
}

class MockRouter extends Mock implements GoRouter {}
