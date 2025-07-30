# TryInhouse SDK ProGuard rules
-keep class co.tryinhouse.android.** { *; }
-keepclassmembers class co.tryinhouse.android.** {
    *;
}

# React Native rules
-keep class com.facebook.react.** { *; }
-keep class com.facebook.hermes.** { *; }

# Keep React Native bridge classes
-keep class com.facebook.react.bridge.** { *; } 