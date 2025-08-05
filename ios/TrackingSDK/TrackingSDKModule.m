//
//  TrackingSDKModule.m
//  react-native-inhouse-sdk
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(TrackingSDK, RCTEventEmitter)

RCT_EXTERN_METHOD(initialize:(NSString *)projectId 
                 projectToken:(NSString *)projectToken 
                 shortLinkDomain:(NSString *)shortLinkDomain
                 serverUrl:(NSString *)serverUrl
                 enableDebugLogging:(BOOL)enableDebugLogging
                 resolver:(RCTPromiseResolveBlock)resolver
                 rejecter:(RCTPromiseRejectBlock)rejecter)

RCT_EXTERN_METHOD(onAppResume:(RCTPromiseResolveBlock)resolver
                 rejecter:(RCTPromiseRejectBlock)rejecter)

RCT_EXTERN_METHOD(trackAppOpen:(NSString *)shortLink
                 resolver:(RCTPromiseResolveBlock)resolver
                 rejecter:(RCTPromiseRejectBlock)rejecter)

RCT_EXTERN_METHOD(trackSessionStart:(NSString *)shortLink
                 resolver:(RCTPromiseResolveBlock)resolver
                 rejecter:(RCTPromiseRejectBlock)rejecter)

RCT_EXTERN_METHOD(trackShortLinkClick:(NSString *)shortLink
                 deepLink:(NSString *)deepLink
                 resolver:(RCTPromiseResolveBlock)resolver
                 rejecter:(RCTPromiseRejectBlock)rejecter)

RCT_EXTERN_METHOD(getInstallReferrer:(RCTPromiseResolveBlock)resolver
                 rejecter:(RCTPromiseRejectBlock)rejecter)

RCT_EXTERN_METHOD(fetchInstallReferrer:(RCTPromiseResolveBlock)resolver
                 rejecter:(RCTPromiseRejectBlock)rejecter)

RCT_EXTERN_METHOD(resetFirstInstall:(RCTPromiseResolveBlock)resolver
                 rejecter:(RCTPromiseRejectBlock)rejecter)

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

@end