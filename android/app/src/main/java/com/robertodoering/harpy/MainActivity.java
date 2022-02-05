package com.robertodoering.harpy;

import android.view.View;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);

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
}
