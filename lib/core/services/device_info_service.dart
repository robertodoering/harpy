import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rby/rby.dart';

/// Provides application and device information using the `package_info_plus`
/// and `device_info_plus` plugins.
///
/// * https://pub.dev/packages/package_info_plus
/// * https://pub.dev/packages/device_info_plus
final deviceInfoProvider =
    StateNotifierProvider<DeviceInfoNotifier, DeviceInfo>(
  (ref) => DeviceInfoNotifier(),
  name: 'DeviceInfoProvider',
);

class DeviceInfoNotifier extends StateNotifier<DeviceInfo> {
  DeviceInfoNotifier() : super(const DeviceInfo());

  Future<void> initialize() async {
    final result = await Future.wait<void>([
      PackageInfo.fromPlatform().handleError(logErrorHandler),
      DeviceInfoPlugin().androidInfo.handleError(),
      DeviceInfoPlugin().iosInfo.handleError(),
    ]);

    state = DeviceInfo(
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
