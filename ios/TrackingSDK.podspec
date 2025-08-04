require 'json'

package = JSON.parse(File.read(File.join(__dir__, '..', 'package.json')))

Pod::Spec.new do |s|
  s.name         = package['name']
  s.version      = package['version']
  s.summary      = package['description']
  s.homepage     = package['homepage']
  s.license      = package['license']
  s.author       = package['author']
  s.platform     = :ios, "14.0"
  s.source       = { :git => "https://github.com/28harishkumar/inhouse-react-native.git", :tag => "#{s.version}" }
  s.source_files = "TrackingSDK/**/*.{h,m,swift}"
  s.requires_arc = true

  s.dependency "React-Core"
  
  # Add the actual iOS SDK dependency from GitHub
  s.dependency "InhouseTrackingSDK", :git => 'https://github.com/28harishkumar/inhouse-tracking-sdk-ios.git', :tag => 'v1.0.0'
  
  # Make sure the pod can be used with different React Native versions
  s.pod_target_xcconfig = { 
    'DEFINES_MODULE' => 'YES',
    'SWIFT_COMPILATION_MODE' => 'wholemodule'
  }
  
  s.swift_version = '5.0'
end 