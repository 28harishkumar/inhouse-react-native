# @tryinhouse/react-native-inhouse-sdk

[![npm version](https://badge.fury.io/js/%40tryinhouse%2Freact-native-inhouse-sdk.svg)](https://badge.fury.io/js/%40tryinhouse%2Freact-native-inhouse-sdk)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A powerful React Native SDK for tracking user interactions, app installs, and deep linking with install referrer support. Built for seamless integration with the TryInHouse platform.

## 🚀 Features

- 📱 **Cross-platform**: Works on both iOS and Android
- 🔗 **Deep Linking**: Handle custom schemes and universal/app links
- 📊 **Event Tracking**: Track app opens, sessions, and custom events
- 🎯 **Install Attribution**: Advanced install referrer tracking

## 📋 Prerequisites

- React Native 0.60.0 or higher
- iOS 16.0+ / Android API level 24+
- CocoaPods (for iOS)

## 📦 Installation

### Using npm

```bash
npm install @tryinhouse/react-native-inhouse-sdk
```

### Using yarn

```bash
yarn add @tryinhouse/react-native-inhouse-sdk
```

## 🔧 Platform Setup

### iOS Setup

1. **Install CocoaPods dependencies:**

```bash
cd ios && pod install
```

2. **Add Thumbmark Swift Package Dependency:**

The SDK requires the [Thumbmark Swift](https://github.com/thumbmarkjs/thumbmark-swift) package for device fingerprinting and secure identification.

**Option A: Using Xcode (Recommended)**

1. Open your iOS project in Xcode (`ios/YourApp.xcworkspace`)
2. Go to **File → Add Package Dependencies...**
3. Enter the repository URL: `https://github.com/thumbmarkjs/thumbmark-swift`
4. Select **Up to Next Major Version** and click **Add Package**
5. Select the **Thumbmark** target and click **Add Package**

**Option B: Using Package.swift (for SPM projects)**
Add the following to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/thumbmarkjs/thumbmark-swift", from: "1.1.0")
]
```

3. **Configure URL Schemes** in `ios/YourApp/Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>your-app-identifier</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>myiosapp</string>
        </array>
    </dict>
</array>
```

4. **Add Associated Domains** for universal links:

```xml
<key>com.apple.developer.associated-domains</key>
<array>
    <string>applinks:your-shortlink-domain.tryinhouse.co</string>
</array>
```

### Android Setup

The SDK uses React Native's autolinking feature for automatic integration.

1. **Add Install Referrer Receiver** to `android/app/src/main/AndroidManifest.xml`:

```xml
<application>
    <!-- Your existing application content -->

    <!-- Install Referrer Receiver -->
    <receiver
        android:name="co.tryinhouse.android.InstallReferrerReceiver"
        android:exported="true">
        <intent-filter>
            <action android:name="com.android.vending.INSTALL_REFERRER" />
        </intent-filter>
    </receiver>
</application>
```

2. **Configure Deep Link Intent Filters** in your main activity:

```xml
<activity
    android:name=".MainActivity"
    android:exported="true"
    android:launchMode="singleTop"
    android:theme="@style/AppTheme">

    <!-- Existing intent filters -->

    <!-- Custom Scheme Deep Links -->
    <intent-filter>
        <action android:name="android.intent.action.VIEW"/>
        <category android:name="android.intent.category.DEFAULT"/>
        <category android:name="android.intent.category.BROWSABLE"/>
        <data android:scheme="myandroidapp"/>
    </intent-filter>

    <!-- App Links (Universal Links) -->
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="https" />
        <data android:host="your-shortlink-domain.tryinhouse.co" />
    </intent-filter>
</activity>
```

## 🔗 TryInHouse Platform Configuration

After setting up the mobile app configurations above, you need to configure the well-known files in your [TryInHouse dashboard](https://app.tryinhouse.co/) to enable proper deep linking verification.

### Configure Well-Known Files

1. **Log in to TryInHouse Dashboard:**

   - Go to [https://app.tryinhouse.co/](https://app.tryinhouse.co/)
   - Sign in to your account or create a new one

2. **Navigate to Project Settings:**

   - Select your project from the dashboard
   - Go to **Settings** → **Linkings**

3. **Configure iOS Universal Links (apple-app-site-association):**

Add the following configuration for iOS universal links:

```json
{
  "applinks": {
    "details": [
      {
        "appIDs": ["TEAMID.com.yourcompany.yourapp"],
        "components": [
          {
            "/#": "*",
            "exclude": true,
            "comment": "Matches any URL with a fragment identifier"
          },
          {
            "/?*": "*",
            "comment": "Matches any URL with query parameters"
          },
          {
            "/": "*",
            "comment": "Matches the root URL and any path"
          }
        ]
      }
    ]
  },
  "webcredentials": {
    "apps": ["TEAMID.com.yourcompany.yourapp"]
  }
}
```

**Important:** Replace `TEAMID.com.yourcompany.yourapp` with your actual Team ID and Bundle Identifier from your iOS app.

4. **Configure Android App Links (assetlinks.json):**

Add the following configuration for Android app links:

```json
[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "com.yourcompany.yourapp",
      "sha256_cert_fingerprints": ["YOUR_APP_SHA256_FINGERPRINT"]
    }
  }
]
```

**Important:** Replace the following values:

- `com.yourcompany.yourapp` with your Android package name
- `YOUR_APP_SHA256_FINGERPRINT` with your app's SHA256 certificate fingerprint

5. **Get Your Android SHA256 Fingerprint:**

For **debug builds**:

```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

For **release builds**:

```bash
keytool -list -v -keystore /path/to/your/release.keystore -alias your-key-alias
```

6. **Save and Deploy:**
   - Save the configurations in your TryInHouse dashboard
   - The platform will automatically deploy these files to your domain
   - Files will be accessible at:
     - `https://your-shortlink-domain.tryinhouse.co/.well-known/apple-app-site-association`
     - `https://your-shortlink-domain.tryinhouse.co/.well-known/assetlinks.json`

### Verify Configuration

**Test iOS Universal Links:**

```bash
# Test the apple-app-site-association file
curl -s https://your-shortlink-domain.tryinhouse.co/.well-known/apple-app-site-association | jq .
```

**Test Android App Links:**

```bash
# Test the assetlinks.json file
curl -s https://your-shortlink-domain.tryinhouse.co/.well-known/assetlinks.json | jq .

# Verify with Google's validation tool
# https://developers.google.com/digital-asset-links/tools/generator
```

**Test Deep Link Handling:**

```bash
# Android testing
adb shell am start -W -a android.intent.action.VIEW -d "https://your-shortlink-domain.tryinhouse.co/test" com.yourcompany.yourapp

# iOS testing (use iOS Simulator)
xcrun simctl openurl booted "https://your-shortlink-domain.tryinhouse.co/test"
```

### Manual Linking (Legacy React Native)

<details>
<summary>Click to expand manual linking instructions</summary>

#### Android

1. **Add to `android/settings.gradle`:**

```gradle
include ':react-native-inhouse-sdk'
project(':react-native-inhouse-sdk').projectDir = new File(rootProject.projectDir, '../node_modules/@tryinhouse/react-native-inhouse-sdk/android')
```

2. **Add to `android/app/build.gradle`:**

```gradle
dependencies {
    implementation project(':react-native-inhouse-sdk')
    // ... other dependencies
}
```

3. **Update `MainApplication.java`:**

```java
import co.tryinhouse.react_native.TrackingSDKPackage;

public class MainApplication extends Application implements ReactApplication {
    // ...

    @Override
    protected List<ReactPackage> getPackages() {
        return Arrays.<ReactPackage>asList(
            new MainReactPackage(),
            new TrackingSDKPackage() // Add this line
        );
    }
}
```

</details>

## 🚀 Quick Start

### 1. Initialize the SDK

```typescript
import TrackingSDK from "@tryinhouse/react-native-inhouse-sdk";

// Initialize in your App.js or App.tsx
const initializeSDK = async () => {
  try {
    await TrackingSDK.initialize(
      "your-project-id", // Project ID from TryInHouse dashboard
      "your-project-token", // Project token from TryInHouse dashboard
      "your-shortlink-domain", // Your custom domain (e.g., 'myapp.tryinhouse.co')
      "https://api.tryinhouse.co", // Optional: API endpoint
      __DEV__ // Enable debug logging in development
    );

    console.log("SDK initialized successfully");
  } catch (error) {
    console.error("SDK initialization failed:", error);
  }
};

// Call during app startup
initializeSDK();
```

### 2. Handle App Lifecycle

```typescript
import { AppState } from "react-native";

useEffect(() => {
  const handleAppStateChange = (nextAppState: string) => {
    if (nextAppState === "active") {
      TrackingSDK.onAppResume();
    }
  };

  const subscription = AppState.addEventListener(
    "change",
    handleAppStateChange
  );
  return () => subscription?.remove();
}, []);
```

### 3. Track Events

```typescript
// Track app open (typically in App.js)
const trackAppOpen = async () => {
  try {
    const result = await TrackingSDK.trackAppOpen();
    console.log("App open tracked:", result);
  } catch (error) {
    console.error("Failed to track app open:", error);
  }
};

// Track session start
const trackSession = async () => {
  try {
    const result = await TrackingSDK.trackSessionStart();
    console.log("Session tracked:", result);
  } catch (error) {
    console.error("Failed to track session:", error);
  }
};
```

## 📖 Detailed Usage

### Event Tracking

#### Track App Open

```typescript
// Basic app open tracking
await TrackingSDK.trackAppOpen();

// Track app open with specific shortlink
await TrackingSDK.trackAppOpen("https://myapp.tryinhouse.co/abc123");
```

#### Track Session Start

```typescript
// Basic session tracking
await TrackingSDK.trackSessionStart();

// Track session with shortlink context
await TrackingSDK.trackSessionStart("https://myapp.tryinhouse.co/xyz789");
```

#### Track Short Link Clicks

```typescript
// Track when user clicks on a short link
await TrackingSDK.trackShortLinkClick(
  "https://myapp.tryinhouse.co/campaign1", // Short link URL
  "myapp://product/123" // Optional: Deep link destination
);
```

### Install Referrer Tracking

```typescript
// Get stored install referrer
const getStoredReferrer = async () => {
  try {
    const referrer = await TrackingSDK.getInstallReferrer();
    console.log("Stored referrer:", referrer);
  } catch (error) {
    console.error("Error getting referrer:", error);
  }
};

// Fetch fresh install referrer data
const fetchFreshReferrer = async () => {
  try {
    const referrer = await TrackingSDK.fetchInstallReferrer();
    console.log("Fresh referrer:", referrer);
  } catch (error) {
    console.error("Error fetching referrer:", error);
  }
};
```

### Real-time Event Callbacks

```typescript
import { useEffect, useState } from 'react';

const useSDKCallbacks = () => {
  useEffect(() => {
    // Add callback listener
    const subscription = TrackingSDK.addCallbackListener((data) => {
      console.log('SDK Event:', data.callbackType);
      console.log('Event Data:', data.data);

      switch (data.callbackType) {
        case 'session_start_shortlink':
          handleSessionWithShortlink(data.data);
          break;
        case 'app_open_shortlink':
          handleAppOpenFromShortlink(data.data);
          break;
        case 'app_install_from_shortlink':
          handleInstallFromShortlink(data.data);
          break;
        default:
          console.log('Unknown callback type:', data.callbackType);
      }
    });

    // Cleanup function
    return () => {
      TrackingSDK.removeCallbackListener(subscription);
    };
  }, []);
};

// Usage in component
const App = () => {
  useSDKCallbacks();

  return (
    // Your app content
  );
};
```

### Deep Link Handling

```typescript
import { Linking } from "react-native";

const handleDeepLink = (url: string) => {
  console.log("Deep link received:", url);

  // Parse and handle the deep link
  if (url.includes("product/")) {
    const productId = url.split("product/")[1];
    // Navigate to product page
  }
};

useEffect(() => {
  // Handle initial URL (app opened via deep link)
  Linking.getInitialURL().then((url) => {
    if (url) {
      handleDeepLink(url);
    }
  });

  // Handle URLs while app is running
  const subscription = Linking.addEventListener("url", ({ url }) => {
    handleDeepLink(url);
  });

  return () => subscription?.remove();
}, []);
```

## 📊 Event Data Structure

All tracking events return link data with the following structure:

```typescript
interface LinkData {
  id: string;
  domain: string;
  key: string;
  url: string;
  short_link: string;
  title: string;
  description: string;
  image: string;
  utm_source: string;
  utm_medium: string;
  utm_campaign: string;
  utm_term: string;
  utm_content: string;
  ios: string;
  android: string;
  project_id: string;
  folder_id: string;
  playstore: string;
  appstore: string;
  deeplink_path: string;
  link_data: string; // JSON object with custom key-value pairs
  website_link: string;
  refer_code: string;
  unique_clicks: number;
  app_installs: number;
}
```

## ⚙️ Configuration

### Dependency Versions

You can override dependency versions in your `android/build.gradle`:

```gradle
ext {
    okhttpVersion = '4.12.0'
    gsonVersion = '2.10.1'
    installReferrerVersion = '2.2'
    coroutinesVersion = '1.7.3'
    coreKtxVersion = '1.12.0'
    appcompatVersion = '1.6.1'
}
```

### Debug Mode

Enable comprehensive logging during development:

```typescript
await TrackingSDK.initialize(
  "project-id",
  "project-token",
  "domain",
  "https://api.tryinhouse.co",
  true // Enable debug logging
);
```

## 🧪 Testing

### Reset First Install State

For testing install attribution:

```typescript
// Reset first install state (use only for testing)
await TrackingSDK.resetFirstInstall();
```

### Example Test Scenarios

```typescript
// Test deep link handling
const testDeepLink = async () => {
  const shortLink = "https://myapp.tryinhouse.co/test123";
  const deepLink = "myapp://home?tab=featured";

  await TrackingSDK.trackShortLinkClick(shortLink, deepLink);
};

// Test install referrer
const testInstallReferrer = async () => {
  const referrer = await TrackingSDK.fetchInstallReferrer();
  console.log("Test referrer:", referrer);
};
```

## 🔧 Troubleshooting

<details>
<summary>Common Issues and Solutions</summary>

### Build Errors

**Problem**: Build fails with dependency conflicts
**Solution**: Ensure you're using compatible React Native version (0.60+)

```bash
npx react-native doctor
```

### iOS Pod Install Issues

**Problem**: CocoaPods installation fails
**Solution**:

```bash
cd ios
rm -rf Pods Podfile.lock
pod cache clean --all
pod install
```

### Android Linking Issues

**Problem**: SDK not found or linking errors
**Solution**: Clean and rebuild

```bash
cd android
./gradlew clean
cd ..
npx react-native run-android
```

### Deep Links Not Working

**Problem**: Deep links not opening the app
**Solution**:

1. Verify AndroidManifest.xml intent filters
2. Check iOS URL schemes in Info.plist
3. Test with `adb` command:

```bash
adb shell am start -W -a android.intent.action.VIEW -d "myapp://test" com.yourapp
```

### Install Referrer Not Tracked

**Problem**: Install referrer data is empty
**Solution**:

1. Verify InstallReferrerReceiver is added to AndroidManifest.xml
2. Test with Google Play Console's internal testing
3. Check that app is installed from Play Store, not sideloaded

</details>

## 📚 API Reference

### Core Methods

| Method                   | Description          | Parameters                                                        | Returns                   |
| ------------------------ | -------------------- | ----------------------------------------------------------------- | ------------------------- |
| `initialize()`           | Initialize the SDK   | `projectId`, `projectToken`, `domain`, `serverUrl?`, `debugMode?` | `Promise<void>`           |
| `onAppResume()`          | Handle app resume    | None                                                              | `Promise<void>`           |
| `trackAppOpen()`         | Track app open event | `shortLink?`                                                      | `Promise<TrackingResult>` |
| `trackSessionStart()`    | Track session start  | `shortLink?`                                                      | `Promise<TrackingResult>` |
| `trackShortLinkClick()`  | Track link click     | `shortLink`, `deepLink?`                                          | `Promise<TrackingResult>` |
| `getInstallReferrer()`   | Get stored referrer  | None                                                              | `Promise<string>`         |
| `fetchInstallReferrer()` | Fetch fresh referrer | None                                                              | `Promise<string>`         |
| `resetFirstInstall()`    | Reset install state  | None                                                              | `Promise<void>`           |

### Event Listeners

| Method                     | Description              | Parameters                 | Returns               |
| -------------------------- | ------------------------ | -------------------------- | --------------------- |
| `addCallbackListener()`    | Add event listener       | `callback: (data) => void` | `EmitterSubscription` |
| `removeCallbackListener()` | Remove specific listener | `subscription`             | `void`                |
| `removeAllListeners()`     | Remove all listeners     | None                       | `void`                |

### TypeScript Types

```typescript
interface TrackingSDKCallback {
  callbackType:
    | "session_start_shortlink"
    | "app_open_shortlink"
    | "app_install_from_shortlink";
  data: LinkData;
}

interface TrackingResult {
  success: boolean;
  data?: LinkData;
  error?: string;
}
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Links

- [TryInHouse Platform](https://tryinhouse.co)
- [Documentation](https://docs.tryinhouse.co)
- [GitHub Repository](https://github.com/28harishkumar/inhouse-react-native)
- [npm Package](https://www.npmjs.com/package/@tryinhouse/react-native-inhouse-sdk)

## 📞 Support

- 📧 Email: support@tryinhouse.co
- 🐛 [Report Issues](https://github.com/28harishkumar/inhouse-react-native/issues)
- 💬 [Discussions](https://github.com/28harishkumar/inhouse-react-native/discussions)

---

Made with ❤️ by the TryInHouse team
