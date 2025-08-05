require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))
folly_compiler_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -Wno-comma -Wno-shorten-64-to-32'

Pod::Spec.new do |s|
  s.name         = package['name']
  s.version      = package['version']
  s.summary      = package['description']
  s.description  = package['description'] || package['summary']
  s.homepage     = package['homepage']
  s.license      = package['license']
  s.author       = package['author']

  # Use platforms instead of platform for better compatibility
  s.platforms    = { :ios => "13.4" }
  s.source       = { :git => "https://github.com/28harishkumar/inhouse-react-native.git", :tag => "#{s.version}" }

  # Source files - include all necessary files
  s.source_files = "ios/TrackingSDK/**/*.{h,m,mm,swift}"
  
  # Public headers - be more specific to avoid issues
  s.public_header_files = [
    "ios/TrackingSDK/TrackingSDKModule.h",
    "ios/TrackingSDK/react-native-inhouse-sdk-umbrella.h"
  ]
  
  # Header directory and module map
  s.header_dir = 'TrackingSDK'
  # s.module_map = "ios/TrackingSDK/module.modulemap"
  s.requires_arc = true

  # React Native new architecture support
  s.pod_target_xcconfig = {
    "USE_HEADERMAP" => "YES",
    "DEFINES_MODULE" => "YES",
    "SWIFT_COMPILATION_MODE" => "wholemodule",
    "SWIFT_OBJC_INTERFACE_HEADER_NAME" => "react-native-inhouse-sdk-Swift.h",
    "HEADER_SEARCH_PATHS" => "$(inherited) \"$(PODS_ROOT)/boost\" \"$(PODS_ROOT)/RCT-Folly\" \"$(PODS_ROOT)/DoubleConversion\" \"$(PODS_ROOT)/Headers/Public/React-Core\"",
    "SWIFT_OBJC_BRIDGING_HEADER" => "$(PODS_TARGET_SRCROOT)/ios/TrackingSDK/TrackingSDK-Bridging-Header.h",
    "CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER" => "NO",
    "OTHER_LDFLAGS" => "-ObjC"
  }

  # Compiler flags
  s.compiler_flags = folly_compiler_flags

  # Try to use install_modules_dependencies if available (React Native 0.71+)
  if respond_to?(:install_modules_dependencies, true)
    install_modules_dependencies(s)
  else
    # Fallback for older React Native versions
    s.dependency "React-Core"
    
    # New architecture support for older RN versions
    if ENV['RCT_NEW_ARCH_ENABLED'] == '1'
      s.compiler_flags += ' -DRCT_NEW_ARCH_ENABLED=1'
      s.dependency "React-Codegen"
      s.dependency "RCT-Folly"
      s.dependency "RCTRequired"
      s.dependency "RCTTypeSafety"
      s.dependency "ReactCommon/turbomodule/core"
    end
  end

  # Add dependency on the iOS SDK
  #s.dependency "InhouseTrackingSDK", "~> 1.0.2"
  #s.dependency "InhouseTrackingSDK", :git => "https://github.com/28harishkumar/inhouse-tracking-sdk-ios.git", :tag => "v1.0.2"


  # Swift version
  s.swift_version = '5.0'
end