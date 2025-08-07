module.exports = {
  dependencies: {
    "react-native-inhouse-sdk": {
      platforms: {
        android: {
          sourceDir: "./android",
          packageImportPath:
            "import co.tryinhouse.react_native.TrackingSDKPackage;",
          packageInstance: "new TrackingSDKPackage()",
        },
        ios: {
          podspecPath: "./react-native-inhouse-sdk.podspec",
        },
      },
    },
  },
};
