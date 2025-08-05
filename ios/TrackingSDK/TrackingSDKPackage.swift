import Foundation
import React
import InhouseTrackingSDK

@objc(TrackingSDKPackage)
class TrackingSDKPackage: NSObject {
    
    @objc
    static func requiresMainQueueSetup() -> Bool {
        return false
    }
    
    @objc
    func initialize(_ config: [String: Any], 
                   resolver resolve: @escaping RCTPromiseResolveBlock,
                   rejecter reject: @escaping RCTPromiseRejectBlock) {
        
        DispatchQueue.main.async {
            do {
                // Initialize your InhouseTrackingSDK here
                // Example: InhouseTrackingSDK.initialize(with: config)
                
                resolve(["success": true])
            } catch {
                reject("INIT_ERROR", "Failed to initialize SDK", error)
            }
        }
    }
    
    @objc
    func trackEvent(_ eventName: String, 
                   properties: [String: Any]?,
                   resolver resolve: @escaping RCTPromiseResolveBlock,
                   rejecter reject: @escaping RCTPromiseRejectBlock) {
        
        DispatchQueue.main.async {
            do {
                // Track event using your SDK
                // Example: InhouseTrackingSDK.track(event: eventName, properties: properties)
                
                resolve(["tracked": true])
            } catch {
                reject("TRACK_ERROR", "Failed to track event", error)
            }
        }
    }
    
    @objc
    func getUserId(_ resolve: @escaping RCTPromiseResolveBlock,
                  rejecter reject: @escaping RCTPromiseRejectBlock) {
        
        DispatchQueue.main.async {
            // Get user ID from your SDK
            // let userId = InhouseTrackingSDK.getUserId()
            resolve(["userId": "example_user_id"])
        }
    }
}

// MARK: - RCTBridgeModule
extension TrackingSDKPackage: RCTBridgeModule {
    
    static func moduleName() -> String! {
        return "TrackingSDKPackage"
    }
    
    func methodQueue() -> DispatchQueue! {
        return DispatchQueue.main
    }
    
    func constantsToExport() -> [AnyHashable: Any]! {
        return [
            "SDK_VERSION": "1.0.0",
            "PLATFORM": "iOS"
        ]
    }
}