# Integration Example

This document provides a step-by-step guide for integrating the TryInhouse Android SDK into your Android project.

## Step 1: Add the AAR to your project

1. Copy `client-release.aar` to your project's `app/libs/` directory
2. Create the directory if it doesn't exist

## Step 2: Update build.gradle

Add the following to your app's `build.gradle`:

```gradle
android {
    // ... existing config ...

    repositories {
        // ... existing repositories ...
        flatDir {
            dirs 'libs'
        }
    }
}

dependencies {
    // ... existing dependencies ...

    // Add the SDK AAR
    implementation(name: 'client-release', ext: 'aar')

    // Required dependencies
    implementation 'com.squareup.okhttp3:okhttp:4.12.0'
    implementation 'com.google.code.gson:gson:2.10.1'
    implementation 'com.android.installreferrer:installreferrer:2.2'
    implementation 'org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.3'
}
```

## Step 3: Add ProGuard Rules

Add the following to your `app/proguard-rules.pro`:

```proguard
# TryInhouse SDK ProGuard rules
-keep class co.tryinhouse.android.** { *; }
-keepclassmembers class co.tryinhouse.android.** {
    *;
}
```

## Step 4: Initialize the SDK

Create or update your Application class:

```kotlin
package com.example.myapp

import android.app.Application
import co.tryinhouse.android.TrackingSDK

class MyApplication : Application() {
    override fun onCreate() {
        super.onCreate()

        // Initialize the SDK with your API key
        TrackingSDK.initialize(this, "YOUR_API_KEY_HERE")
    }
}
```

Update your `AndroidManifest.xml`:

```xml
<application
    android:name=".MyApplication"
    ... >
    <!-- ... rest of your manifest ... -->
</application>
```

## Step 5: Track Events

In your activities or fragments:

```kotlin
import co.tryinhouse.android.EventTracker

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // Track app open
        EventTracker.trackAppOpen()

        // Track custom events
        findViewById<Button>(R.id.button).setOnClickListener {
            EventTracker.trackEvent("button_click", mapOf(
                "button_id" to "main_button",
                "screen" to "main_activity"
            ))
        }
    }
}
```

## Step 6: Handle Deep Links

Create a DeepLinkActivity or update your existing activity:

```kotlin
import co.tryinhouse.android.DeepLinkHandler

class DeepLinkActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_deep_link)

        // Handle the deep link
        intent.data?.let { uri ->
            DeepLinkHandler.handleDeepLink(this, uri)
        }
    }
}
```

Add to your `AndroidManifest.xml`:

```xml
<activity
    android:name=".DeepLinkActivity"
    android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="https" />
        <data android:host="your-domain.com" />
    </intent-filter>
</activity>
```

## Step 7: Test the Integration

1. Build and run your app
2. Check the logs for SDK initialization messages
3. Test event tracking by performing actions in your app
4. Test deep link handling by opening a link that matches your scheme

## Troubleshooting

### Common Issues

1. **Build errors**: Make sure all required dependencies are included
2. **Runtime crashes**: Check that the SDK is properly initialized
3. **ProGuard issues**: Ensure ProGuard rules are correctly applied
4. **Network errors**: Verify internet permissions are granted

### Debug Mode

Enable debug logging by adding this before SDK initialization:

```kotlin
// Enable debug mode (remove in production)
TrackingSDK.setDebugMode(true)
```

## Next Steps

1. Replace `YOUR_API_KEY_HERE` with your actual API key
2. Customize event tracking based on your app's needs
3. Set up deep link handling for your specific use case
4. Test thoroughly in your development environment
