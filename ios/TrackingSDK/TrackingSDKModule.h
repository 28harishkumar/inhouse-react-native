//
//  TrackingSDKModule.h
//  react-native-inhouse-sdk
//

#import <Foundation/Foundation.h>

#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#elif __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#import "RCTEventEmitter.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface TrackingSDKModule : RCTEventEmitter <RCTBridgeModule>

@end

NS_ASSUME_NONNULL_END