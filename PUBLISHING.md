# Publishing to npm

This document contains instructions for publishing the React Native Tracking SDK module to npm.

## Prerequisites

1. Make sure you have an npm account
2. Login to npm: `npm login`
3. Ensure you have the necessary permissions to publish

## Pre-publishing Checklist

1. **Update version number** in `package.json`
2. **Update repository URL** in `package.json` to point to your actual repository
3. **Update author information** in `package.json`
4. **Test the build**: `npm run build`
5. **Run tests**: `npm test`
6. **Check linting**: `npm run lint`

## Publishing Steps

1. **Build the project**:

   ```bash
   npm run build
   ```

2. **Test the build**:

   ```bash
   npm test
   ```

3. **Check what will be published**:

   ```bash
   npm pack
   ```

4. **Publish to npm**:
   ```bash
   npm publish
   ```

## Post-publishing

1. **Tag the release** in your git repository
2. **Create a GitHub release** with release notes
3. **Update documentation** if needed

## Important Notes

- The module uses `peerDependencies` for React and React Native, so users need to install these themselves
- The native Android and iOS code needs to be properly integrated with the actual native SDKs
- Update the Android and iOS native module files to use your actual native SDK implementations
- Make sure to update the package name and repository URLs before publishing

## File Structure

```
react-native-tracking-sdk/
├── src/
│   ├── index.ts                 # Main TypeScript source
│   └── __tests__/
│       └── index.test.ts        # Tests
├── android/
│   ├── build.gradle             # Android build configuration
│   └── src/main/
│       ├── AndroidManifest.xml  # Android manifest
│       └── java/co/tryinhouse/react_native/
│           ├── TrackingSDKModule.kt    # Android native module
│           └── TrackingSDKPackage.kt   # Android package
├── ios/
│   ├── TrackingSDK.podspec      # iOS podspec
│   └── TrackingSDK/
│       ├── TrackingSDKModule.swift    # iOS native module
│       └── TrackingSDKModule.m        # iOS bridge
├── example/
│   └── App.tsx                  # Example usage
├── package.json                 # npm package configuration
├── tsconfig.json               # TypeScript configuration
├── README.md                   # Documentation
└── LICENSE                     # MIT License
```

## Integration Notes

### For Android

- Update the `TrackingSDKModule.kt` to use your actual native Android SDK
- Add your native SDK dependency in `android/build.gradle`
- Update the package name to match your organization

### For iOS

- Update the `TrackingSDKModule.swift` to use your actual native iOS SDK
- Add your native SDK dependency in `ios/TrackingSDK.podspec`
- Update the module name to match your organization

### For Users

Users will need to:

1. Install the package: `npm install react-native-tracking-sdk`
2. Link the native modules (usually automatic with React Native 0.60+)
3. For iOS: `cd ios && pod install`
4. Import and use the SDK in their React Native code

## Version Management

- Use semantic versioning (MAJOR.MINOR.PATCH)
- Update the version in `package.json` before publishing
- Create git tags for each release
- Update the changelog with release notes
