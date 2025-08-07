#import "TrackingSDKModule.h"
#import <React/RCTLog.h>

@implementation TrackingSDKModule

RCT_EXPORT_MODULE(TrackingSDK);

- (NSArray<NSString *> *)supportedEvents {
  return @[@"onSdkCallback"];
}

RCT_EXPORT_METHOD(initialize:(NSString *)projectId
                  projectToken:(NSString *)projectToken
                  shortLinkDomain:(NSString *)shortLinkDomain
                  serverUrl:(NSString *)serverUrl
                  enableDebugLogging:(BOOL)enableDebugLogging
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  RCTLogInfo(@"TrackingSDK: initialize called with projectId: %@", projectId);
  resolve(@"Mock initialization successful");
}

RCT_EXPORT_METHOD(onAppResume:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  RCTLogInfo(@"TrackingSDK: onAppResume called");
  resolve(nil);
}

RCT_EXPORT_METHOD(trackAppOpen:(NSString *)shortLink
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  RCTLogInfo(@"TrackingSDK: trackAppOpen called with shortLink: %@", shortLink);
  resolve(@"Mock app open tracked");
}

RCT_EXPORT_METHOD(trackSessionStart:(NSString *)shortLink
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  RCTLogInfo(@"TrackingSDK: trackSessionStart called with shortLink: %@", shortLink);
  resolve(@"Mock session start tracked");
}

RCT_EXPORT_METHOD(trackShortLinkClick:(NSString *)shortLink
                  deepLink:(NSString *)deepLink
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  RCTLogInfo(@"TrackingSDK: trackShortLinkClick called with shortLink: %@, deepLink: %@", shortLink, deepLink);
  resolve(@"Mock short link click tracked");
}

RCT_EXPORT_METHOD(getInstallReferrer:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  RCTLogInfo(@"TrackingSDK: getInstallReferrer called");
  resolve(@"mock_install_referrer_data");
}

RCT_EXPORT_METHOD(fetchInstallReferrer:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  RCTLogInfo(@"TrackingSDK: fetchInstallReferrer called");
  resolve(@"mock_fetched_install_referrer_data");
}

RCT_EXPORT_METHOD(resetFirstInstall:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  RCTLogInfo(@"TrackingSDK: resetFirstInstall called");
  resolve(nil);
}

@end 