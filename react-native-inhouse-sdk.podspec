require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = package['name']
  s.version      = package['version']
  s.summary      = package['description']
  s.description  = package['description'] || package['summary']
  s.homepage     = package['homepage']
  s.license      = package['license']
  s.author       = package['author']

  # iOS 16.0 only - no tvOS, watchOS, etc.
  s.platform     = :ios, "16.0"
  s.source       = { :git => "https://github.com/28harishkumar/inhouse-react-native.git", :tag => "#{s.version}" }

  # Source files - include all necessary files
  s.source_files = "ios/TrackingSDK/**/*.{h,m,mm}"
  
  # Public headers - be more specific to avoid issues
  s.public_header_files = [
    "ios/TrackingSDK/TrackingSDKModule.h"
  ]
  
  # Private headers - exclude umbrella header from public headers
  # s.private_header_files = [
  #   "ios/TrackingSDK/react-native-inhouse-sdk-umbrella.h"
  # ]
  
  # Header directory
  s.header_dir = 'TrackingSDK'
  s.requires_arc = true

  # Only enable framework-specific settings if the user's app is using dynamic frameworks
  # Static frameworks don't need these settings
  # if ENV['USE_FRAMEWORKS'] == 'dynamic'
  #   s.pod_target_xcconfig = {
  #     "DEFINES_MODULE" => "YES",
  #     "SWIFT_OBJC_INTERFACE_HEADER_NAME" => "react-native-inhouse-sdk-Swift.h",
  #     "SWIFT_OBJC_BRIDGING_HEADER" => "$(PODS_TARGET_SRCROOT)/ios/TrackingSDK/TrackingSDK-Bridging-Header.h"
  #   }
  # end

  # Try to use install_modules_dependencies if available (React Native 0.71+)
  if respond_to?(:install_modules_dependencies, true)
    install_modules_dependencies(s)
  else
    # Fallback for older React Native versions
    s.dependency "React-Core"
    
    # New architecture support for older RN versions
    if ENV['RCT_NEW_ARCH_ENABLED'] == '1'
      s.dependency "React-Codegen"
      s.dependency "RCTRequired"
      s.dependency "RCTTypeSafety"
      s.dependency "ReactCommon/turbomodule/core"
    end
  end

  # Add dependency on the iOS SDK
  # s.dependency "InhouseTrackingSDK", :git => "https://github.com/28harishkumar/inhouse-tracking-sdk-ios.git", :tag => "v1.0.3"
  s.dependency "InhouseTrackingSDK", "~> 1.0.3"

  # Swift version
  # s.swift_version = '5.0'
end