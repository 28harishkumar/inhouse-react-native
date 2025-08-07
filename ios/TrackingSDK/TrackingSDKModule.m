#import "TrackingSDKModule.h"
#import <React/RCTLog.h>
@import InhouseTrackingSDK;

@implementation TrackingSDKModule

RCT_EXPORT_MODULE(TrackingSDK);

+ (BOOL)requiresMainQueueSetup {
  return NO;
}

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
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [InhouseTrackingSDK.shared initializeWithProjectId:projectId
                                          projectToken:projectToken
                                      shortLinkDomain:shortLinkDomain
                                           serverUrl:serverUrl
                                  enableDebugLogging:enableDebugLogging
                                           callback:^(NSString *callbackType, NSString *data) {
      [self sendEventWithName:@"onSdkCallback" body:@{
        @"callbackType": callbackType,
        @"data": data
      }];
    }];
    resolve(@"SDK initialized successfully");
  });
}

RCT_EXPORT_METHOD(onAppResume:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  RCTLogInfo(@"TrackingSDK: onAppResume called");
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [InhouseTrackingSDK.shared onAppResume];
    resolve(nil);
  });
}

RCT_EXPORT_METHOD(trackAppOpen:(NSString *)shortLink
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  RCTLogInfo(@"TrackingSDK: trackAppOpen called with shortLink: %@", shortLink);
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [InhouseTrackingSDK.shared trackAppOpenWithShortLink:shortLink callback:^(NSString *responseJson) {
      resolve(responseJson);
    }];
  });
}

RCT_EXPORT_METHOD(trackSessionStart:(NSString *)shortLink
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  RCTLogInfo(@"TrackingSDK: trackSessionStart called with shortLink: %@", shortLink);
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [InhouseTrackingSDK.shared trackSessionStartWithShortLink:shortLink callback:^(NSString *responseJson) {
      resolve(responseJson);
    }];
  });
}

RCT_EXPORT_METHOD(trackShortLinkClick:(NSString *)shortLink
                  deepLink:(NSString *)deepLink
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  RCTLogInfo(@"TrackingSDK: trackShortLinkClick called with shortLink: %@, deepLink: %@", shortLink, deepLink);
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [InhouseTrackingSDK.shared trackShortLinkClickWithShortLink:shortLink deepLink:deepLink callback:^(NSString *responseJson) {
      resolve(responseJson);
    }];
  });
}

RCT_EXPORT_METHOD(getInstallReferrer:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  RCTLogInfo(@"TrackingSDK: getInstallReferrer called");
  
  dispatch_async(dispatch_get_main_queue(), ^{
    NSString *installReferrer = [InhouseTrackingSDK.shared getInstallReferrer];
    resolve(installReferrer ?: @"");
  });
}

RCT_EXPORT_METHOD(fetchInstallReferrer:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  RCTLogInfo(@"TrackingSDK: fetchInstallReferrer called");
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [InhouseTrackingSDK.shared fetchInstallReferrerWithCallback:^(NSString *referrer) {
      resolve(referrer ?: @"");
    }];
  });
}

RCT_EXPORT_METHOD(resetFirstInstall:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  RCTLogInfo(@"TrackingSDK: resetFirstInstall called");
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [InhouseTrackingSDK.shared resetFirstInstall];
    resolve(nil);
  });
}

@end 