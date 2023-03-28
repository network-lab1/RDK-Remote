package io.flutter.plugins;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;
import io.flutter.Log;

import io.flutter.embedding.engine.FlutterEngine;

/**
 * Generated file. Do not edit.
 * This file is generated by the Flutter tool based on the
 * plugins that support the Android platform.
 */
@Keep
public final class GeneratedPluginRegistrant {
  private static final String TAG = "GeneratedPluginRegistrant";
  public static void registerWith(@NonNull FlutterEngine flutterEngine) {
    try {
      flutterEngine.getPlugins().add(new dev.steenbakker.mobile_scanner.MobileScannerPlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin mobile_scanner, dev.steenbakker.mobile_scanner.MobileScannerPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new net.touchcapture.qr.flutterqr.FlutterQrPlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin qr_code_scanner, net.touchcapture.qr.flutterqr.FlutterQrPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.csdcorp.speech_to_text.SpeechToTextPlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin speech_to_text, com.csdcorp.speech_to_text.SpeechToTextPlugin", e);
    }
  }
}