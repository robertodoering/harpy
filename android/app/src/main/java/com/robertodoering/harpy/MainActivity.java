package com.robertodoering.harpy;

import android.os.Bundle;
import android.view.View;

import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(@Nullable Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    final View view = findViewById(android.R.id.content);

    if (view != null) {
      view.setSystemUiVisibility(
        // Tells the system that the window wishes the content to
        // be laid out at the most extreme scenario.
        View.SYSTEM_UI_FLAG_LAYOUT_STABLE |
          // Tells the system that the window wishes the content to
          // be laid out as if the navigation bar was hidden
          View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
      );
    }
  }
}
