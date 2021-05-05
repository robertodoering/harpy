import 'package:device_info/device_info.dart';
import 'package:logging/logging.dart';
import 'package:package_info/package_info.dart';

/// Provides application and device information using the `package_info` and
/// `device_info` plugins.
///
/// See https://pub.dev/packages/package_info and
/// https://pub.dev/packages/device_info.
class HarpyInfo {
  static final Logger _log = Logger('HarpyInfo');

  /// Application metadata.
  PackageInfo? packageInfo;

  /// Information about the device this app is running on.
  ///
  /// Since only android is supported, [IosDeviceInfo] is not used.
  AndroidDeviceInfo? deviceInfo;

  Future<void> initialize() async {
    // await Future.wait<void>(<Future<void>>[
    //   _initPackageInfo(),
    //   _initDeviceInfo(),
    // ]);
  }

  Future<void> _initPackageInfo() async {
    try {
      packageInfo = await PackageInfo.fromPlatform();
    } catch (e, st) {
      _log.warning('error while loading package info', e, st);
    }
  }

  Future<void> _initDeviceInfo() async {
    try {
      deviceInfo = await DeviceInfoPlugin().androidInfo;
    } catch (e, st) {
      _log.warning('error while loading device info', e, st);
    }
  }
}
