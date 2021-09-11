package com.robertodoering.harpy

import android.os.Environment
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class AndroidPathProviderPlugin : FlutterPlugin, MethodCallHandler {

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) = Unit

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) = Unit

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
