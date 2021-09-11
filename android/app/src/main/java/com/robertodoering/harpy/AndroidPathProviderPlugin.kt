package com.robertodoering.harpy

import android.content.Context
import android.os.Environment
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class AndroidPathProviderPlugin : FlutterPlugin, MethodCallHandler {
  private lateinit var context: Context

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    context = binding.applicationContext
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) = Unit

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getAlarmsPath" -> result.success(
        context.getExternalFilesDir(Environment.DIRECTORY_ALARMS)?.absolutePath
      )
      "getDCIMPath" -> result.success(
        context.getExternalFilesDir(Environment.DIRECTORY_DCIM)?.absolutePath
      )
      "getDocumentsPath" -> result.success(
        context.getExternalFilesDir(Environment.DIRECTORY_DOCUMENTS)?.absolutePath
      )
      "getDownloadsPath" -> result.success(
        context.getExternalFilesDir(Environment.DIRECTORY_DOWNLOADS)?.absolutePath
      )
      "getMoviesPath" -> result.success(
        context.getExternalFilesDir(Environment.DIRECTORY_MOVIES)?.absolutePath
      )
      "getMusicPath" -> result.success(
        context.getExternalFilesDir(Environment.DIRECTORY_MUSIC)?.absolutePath
      )
      "getNotificationsPath" -> result.success(
        context.getExternalFilesDir(Environment.DIRECTORY_NOTIFICATIONS)?.absolutePath
      )
      "getPicturesPath" -> result.success(
        context.getExternalFilesDir(Environment.DIRECTORY_PICTURES)?.absolutePath
      )
      "getPodcastsPath" -> result.success(
        context.getExternalFilesDir(Environment.DIRECTORY_PODCASTS)?.absolutePath
      )
      "getRingtonesPath" -> result.success(
        context.getExternalFilesDir(Environment.DIRECTORY_RINGTONES)?.absolutePath
      )
      else -> result.notImplemented()
    }
  }
}
