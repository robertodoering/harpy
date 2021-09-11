package com.robertodoering.harpy

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import android.os.Environment;

class AndroidPathProviderPlugin : MethodCallHandler {
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "android_path_provider")
      channel.setMethodCallHandler(AndroidPathProviderPlugin())
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "getAlarmsPath") {
      result.success(
        Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_ALARMS)
          .getAbsolutePath()
      );
    } else if (call.method == "getDCIMPath") {
      result.success(
        Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM)
          .getAbsolutePath()
      );
    } else if (call.method == "getDocumentsPath") {
      result.success(
        Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOCUMENTS)
          .getAbsolutePath()
      );
    } else if (call.method == "getDownloadsPath") {
      result.success(
        Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
          .getAbsolutePath()
      );
    } else if (call.method == "getMoviesPath") {
      result.success(
        Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MOVIES)
          .getAbsolutePath()
      );
    } else if (call.method == "getMusicPath") {
      result.success(
        Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MUSIC).getAbsolutePath()
      );
    } else if (call.method == "getNotificationsPath") {
      result.success(
        Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_NOTIFICATIONS)
          .getAbsolutePath()
      );
    } else if (call.method == "getPicturesPath") {
      result.success(
        Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES)
          .getAbsolutePath()
      );
    } else if (call.method == "getPodcastsPath") {
      result.success(
        Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PODCASTS)
          .getAbsolutePath()
      );
    } else if (call.method == "getRingtonesPath") {
      result.success(
        Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_RINGTONES)
          .getAbsolutePath()
      );
    } else {
      result.notImplemented()
    }
  }
}
