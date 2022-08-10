package com.robertodoering.harpy;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.verify.domain.DomainVerificationManager;
import android.content.pm.verify.domain.DomainVerificationUserState;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;
import android.view.View;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);

    handleMethodCalls(flutterEngine);

    final View view = findViewById(android.R.id.content);

    if (view != null) {
      view.setSystemUiVisibility(
        // Tells the system that the window wishes the content to
        // be laid out at the most extreme scenario
        View.SYSTEM_UI_FLAG_LAYOUT_STABLE |
          // Tells the system that the window wishes the content to
          // be laid out as if the navigation bar was hidden
          View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
      );
    }
  }

  private void handleMethodCalls(@NonNull FlutterEngine flutterEngine) {
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "com.robertodoering.harpy")
      .setMethodCallHandler(
        (call, result) -> {
          if (call.method.equals("showOpenByDefault")) {
            showOpenByDefault();
            result.success(true);
          } else if (call.method.equals("hasUnapprovedDomains")) {
            result.success(hasUnapprovedDomains());
          } else {
            result.notImplemented();
          }
        }
      );
  }

  private void showOpenByDefault() {
    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
      final Context context = getContext();
      Intent intent;

      if (Build.MANUFACTURER.equalsIgnoreCase("samsung")) {
        // samsung crashes when trying to open the 'open by default' settings page :^)
        // so we open samsung's 'apps that can open links' settings page instead
        // https://stackoverflow.com/questions/70953672/android-12-deep-link-association-by-user-fails-because-of-crash-in-samsung-setti
        intent = new Intent("android.settings.MANAGE_DOMAIN_URLS");
      }
      else {
        intent = new Intent(
          Settings.ACTION_APP_OPEN_BY_DEFAULT_SETTINGS,
          Uri.parse("package:" + context.getPackageName())
        );
      }

      context.startActivity(intent);
    }
  }

  private boolean hasUnapprovedDomains() {
    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
      final Context context = getContext();
      final DomainVerificationManager manager = context.getSystemService(DomainVerificationManager.class);

      DomainVerificationUserState userState;

      try {
        userState = manager.getDomainVerificationUserState(context.getPackageName());
      } catch (PackageManager.NameNotFoundException e) {
        return false;
      }

      return userState.getHostToStateMap()
        .values()
        .stream()
        .anyMatch((stateValue) ->
          stateValue != DomainVerificationUserState.DOMAIN_STATE_VERIFIED &&
          stateValue != DomainVerificationUserState.DOMAIN_STATE_SELECTED
        );
    }

    return false;
  }
}
