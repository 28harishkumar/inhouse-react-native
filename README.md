# React Native Inhouse Tracking SDK

A React Native module for tracking SDK functionality with install referrer support.

## Installation

### Using npm

```bash
npm install react-native-inhouse-sdk
```

### Using yarn

```bash
yarn add react-native-inhouse-sdk
```

## iOS Installation

The SDK uses CocoaPods for iOS. After installation, run:

```bash
cd ios && pod install
```

## Android Installation

The SDK will be automatically linked via React Native's autolinking feature.

### AndroidManifest.xml Configuration

Add the following receiver to your `android/app/src/main/AndroidManifest.xml` inside the `<application>` tag:

```xml
<receiver
  android:name="co.tryinhouse.android.InstallReferrerReceiver"
  android:exported="true">
  <intent-filter>
      <action android:name="com.android.vending.INSTALL_REFERRER" />
  </intent-filter>
</receiver>
```

This receiver is required for install referrer tracking functionality.

#### Intent Filters for Deep Linking

Add the following intent filters to your main activity inside the `<activity>` tag in `android/app/src/main/AndroidManifest.xml`:

```xml
<intent-filter>
    <action android:name="android.intent.action.VIEW"/>
    <category android:name="android.intent.category.DEFAULT"/>
    <category android:name="android.intent.category.BROWSABLE"/>
    <data android:scheme="myandroidapp"/>
</intent-filter>

<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />

    <!-- Do not include other schemes. -->
    <data android:scheme="http" />
    <data android:scheme="https" />

    <data android:host="your-shortlink-domain.tryinhouse.co" />
</intent-filter>
```

These intent filters enable deep linking functionality for your app. The first filter handles custom scheme URLs (e.g., `myandroidapp://`), while the second filter handles HTTP/HTTPS URLs with your TryInHouse domain for App Links verification.

### Manual Linking (if needed)

1. Add the following to your `android/settings.gradle`:

```gradle
include ':react-native-inhouse-sdk'
project(':react-native-inhouse-sdk').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-inhouse-sdk/android')
```

2. Add the following to your `android/app/build.gradle`:

```gradle
dependencies {
    implementation project(':react-native-inhouse-sdk')
}
```

3. Add the following to your `MainApplication.java`:

```java
import co.tryinhouse.react_native.TrackingSDKPackage;

// In the getPackages() method:
packages.add(new TrackingSDKPackage());
```

## Usage

### Basic Setup

```typescript
import TrackingSDK from "react-native-inhouse-sdk";

// Initialize the SDK
await TrackingSDK.initialize(
  "your-project-id",
  "your-project-token",
  "your-shortlink-domain",
  "https://api.tryinhouse.co", // optional
  true // enable debug logging
);
```

### Track Events

```typescript
// Track app open
const result = await TrackingSDK.trackAppOpen("shortlink-url");

// Track session start
const sessionResult = await TrackingSDK.trackSessionStart("shortlink-url");

// Track short link click
const clickResult = await TrackingSDK.trackShortLinkClick(
  "shortlink-url",
  "deeplink-url"
);
```

### Install Referrer

```typescript
// Get install referrer storred in shared preferences
const referrer = await TrackingSDK.getInstallReferrer();

// Fetch install referrer (async)
const fetchedReferrer = await TrackingSDK.fetchInstallReferrer();
```

### Event Listeners

```typescript
// Add callback listener
const subscription = TrackingSDK.addCallbackListener((data) => {
  console.log("SDK Callback:", data.callbackType, data.data);
});

// Remove listener
TrackingSDK.removeCallbackListener(subscription);

// Remove all listeners
TrackingSDK.removeAllListeners();
```

The SDK tracks the following events, all of which send link data:

- `session_start_shortlink`: Triggered when a session starts with a shortlink
- `app_open_shortlink`: Triggered when the app opens via a shortlink
- `app_install_from_shortlink`: Triggered when the app is installed from a shortlink

All events include link data with the following structure:

```json
{
  "id": "string",
  "domain": "string",
  "key": "string",
  "url": "string",
  "short_link": "string",
  "title": "string",
  "description": "string",
  "image": "string",
  "utm_source": "string",
  "utm_medium": "string",
  "utm_campaign": "string",
  "utm_term": "string",
  "utm_content": "string",
  "ios": "string",
  "android": "string",
  "project_id": "string",
  "folder_id": "string",
  "playstore": "string",
  "appstore": "string",
  "deeplink_path": "string",
  "link_data": "string", // json object with custom key value pairs
  "website_link": "string",
  "refer_code": "string",
  "unique_clicks": 0,
  "app_installs": 0
}
```

### App Lifecycle

```typescript
// Call when app resumes
await TrackingSDK.onAppResume();

// Reset first install state (for testing)
await TrackingSDK.resetFirstInstall();
```

## Configuration

The SDK automatically uses the React Native and other dependencies from your project. You can configure specific versions in your project's `android/build.gradle`:

```gradle
ext {
    // SDK will use these versions if available
    okhttpVersion = '4.12.0'
    gsonVersion = '2.10.1'
    installReferrerVersion = '2.2'
    coroutinesVersion = '1.7.3'
    coreKtxVersion = '1.12.0'
    appcompatVersion = '1.6.1'
}
```

## API Reference

### Methods

- `initialize(projectId, projectToken, shortLinkDomain, serverUrl?, enableDebugLogging?)`: Initialize the SDK
- `onAppResume()`: Call when app resumes
- `trackAppOpen(shortLink?)`: Track app open event
- `trackSessionStart(shortLink?)`: Track session start
- `trackShortLinkClick(shortLink, deepLink?)`: Track short link click
- `getInstallReferrer()`: Get current install referrer
- `fetchInstallReferrer()`: Fetch install referrer asynchronously
- `resetFirstInstall()`: Reset first install state
- `addCallbackListener(callback)`: Add event listener
- `removeCallbackListener(subscription)`: Remove specific listener
- `removeAllListeners()`: Remove all listeners

### Types

- `TrackingSDKCallback`: Callback data structure
- `TrackingSDKInterface`: Main SDK interface

## Troubleshooting

### Common Issues

1. **Build errors**: Make sure you have the latest React Native version
2. **Linking issues**: The SDK uses autolinking, but you can manually link if needed
3. **iOS pod install**: Run `cd ios && pod install` after installation

### Debug Mode

Enable debug logging during initialization to see detailed logs:

```typescript
await TrackingSDK.initialize(
  "project-id",
  "project-token",
  "shortlink-domain",
  "https://api.tryinhouse.co",
  true // enable debug logging
);
```

## License

MIT
