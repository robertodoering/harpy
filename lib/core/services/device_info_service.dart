import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harpy/rby/rby.dart';
import 'package:package_info_plus/package_info_plus.dart';

final deviceInfoProvider = StateProvider(
  (ref) => const DeviceInfo(),
  name: 'DeviceInfoProvider',
);

final deviceInfoServiceProvider = Provider(
  DeviceInfoService.new,
  name: 'DeviceInfoServiceProvider',
);

/// Provides application and device information using the `package_info_plus`
/// and `device_info_plus` plugins.
///
/// * https://pub.dev/packages/package_info_plus
/// * https://pub.dev/packages/device_info_plus
class DeviceInfoService {
  DeviceInfoService(this._ref);

  final Ref _ref;

  Future<void> initialize() async {
    final result = await Future.wait<void>([
      PackageInfo.fromPlatform().handleError(logErrorHandler),
      DeviceInfoPlugin().androidInfo.handleError(),
      DeviceInfoPlugin().iosInfo.handleError(),
    ]);

    _ref.read(deviceInfoProvider.notifier).state = DeviceInfo(
      packageInfo: result[0] as PackageInfo?,
      androidDeviceInfo: result[1] as AndroidDeviceInfo?,
      iosDeviceInfo: result[2] as IosDeviceInfo?,
    );
  }
}

class DeviceInfo {
  const DeviceInfo({
    this.packageInfo,
    this.androidDeviceInfo,
    this.iosDeviceInfo,
  });

  /// Application metadata.
  final PackageInfo? packageInfo;

  /// Information about the device this app is running on.
  final AndroidDeviceInfo? androidDeviceInfo;
  final IosDeviceInfo? iosDeviceInfo;
}
