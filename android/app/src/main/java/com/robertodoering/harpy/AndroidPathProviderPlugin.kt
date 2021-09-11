package com.robertodoering.harpy

import android.os.Environment
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class AndroidPathProviderPlugin : MethodCallHandler {
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "android_path_provider")
      channel.setMethodCallHandler(AndroidPathProviderPlugin())
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getAlarmsPath" -> result.success(
        Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_ALARMS)
          .absolutePath
      )
      "getDCIMPath" -> result.success(
        Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM)
          .absolutePath
      )
      "getDocumentsPath" -> result.success(
        Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOCUMENTS)
          .absolutePath
      )
      "getDownloadsPath" -> result.success(
        Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
          .absolutePath
      )
      "getMoviesPath" -> result.success(
        Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MOVIES)
          .absolutePath
      )
      "getMusicPath" -> result.success(
        Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MUSIC).absolutePath
      )
      "getNotificationsPath" -> result.success(
        Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_NOTIFICATIONS)
          .absolutePath
      )
      "getPicturesPath" -> result.success(
        Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES)
          .absolutePath
      )
      "getPodcastsPath" -> result.success(
        Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PODCASTS)
          .absolutePath
      )
      "getRingtonesPath" -> result.success(
        Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_RINGTONES)
          .absolutePath
      )
      else -> result.notImplemented()
    }
  }
}
