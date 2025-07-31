# TryInhouse Android SDK

A lightweight Android SDK for tracking app installs, app opens, and user interactions with shortlinks.

## Contents

This distribution includes:

- `client-release.aar` - The main SDK library file
- `client-sources.jar` - Source code for debugging and development
- `dokka/` - Complete API documentation
- `consumer-rules.pro` - ProGuard rules for consumer apps

## Installation

### Option 1: Local AAR Integration

1. Copy the `client-release.aar` file to your project's `libs/` directory
2. Add the following to your app's `build.gradle`:

```gradle
dependencies {
    implementation fileTree(dir: 'libs', include: ['*.jar', '*.aar'])

    // Required dependencies
    implementation 'com.squareup.okhttp3:okhttp:4.12.0'
    implementation 'com.google.code.gson:gson:2.10.1'
    implementation 'com.android.installreferrer:installreferrer:2.2'
    implementation 'org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.3'
}
```

3. Add ProGuard rules to your app's `proguard-rules.pro`:

```proguard
# Include the consumer rules from the SDK
-keep class co.tryinhouse.android.** { *; }
```

### Option 2: Maven Central (Recommended)

Add the following to your app's `build.gradle`:

```gradle
dependencies {
    implementation 'co.tryinhouse.android:sdk:1.0.0'
}
```

## Usage

### Initialize the SDK

```kotlin
// In your Application class
class MyApplication : Application() {
    override fun onCreate() {
        super.onCreate()

        // Initialize the SDK
        TrackingSDK.initialize(this, "YOUR_API_KEY")
    }
}
```

### Track Events

```kotlin
// Track app open
EventTracker.trackAppOpen()

// Track custom events
EventTracker.trackEvent("user_action", mapOf(
    "action" to "button_click",
    "screen" to "main"
))
```

### Handle Deep Links

```kotlin
// In your MainActivity or DeepLinkActivity
override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)

    // Handle deep links
    DeepLinkHandler.handleDeepLink(this, intent.data)
}
```

## API Documentation

Complete API documentation is available in the `dokka/` directory. Open `dokka/index.html` in your web browser to view the documentation.

## Requirements

- Android API Level 24+ (Android 7.0+)
- Kotlin 1.8+
- AndroidX

## Dependencies

The SDK requires the following dependencies:

- `androidx.core:core-ktx`
- `androidx.appcompat:appcompat`
- `com.squareup.okhttp3:okhttp:4.12.0`
- `com.google.code.gson:gson:2.10.1`
- `com.android.installreferrer:installreferrer:2.2`
- `org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.3`

## License

Apache License 2.0

## Support

For support and questions, please contact:

- Email: ck@tryinhouse.co
- GitHub: https://github.com/28harishkumar/tryinhouse-android-sdk
