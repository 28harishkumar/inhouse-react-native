# Consumer ProGuard rules for TryInhouse SDK
# Include these rules in your app's proguard-rules.pro

# Keep the SDK classes
-keep class co.tryinhouse.android.** { *; }
-keepclassmembers class co.tryinhouse.android.** {
    *;
}

# Keep React Native bridge classes
-keep class com.facebook.react.bridge.** { *; } 