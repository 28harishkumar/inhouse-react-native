import Foundation
import React

@objc(TrackingSDKModule)
class TrackingSDKModule: RCTEventEmitter {
    
    override init() {
        super.init()
    }
    
    override func supportedEvents() -> [String]! {
        return ["onSdkCallback"]
    }
    
    @objc
    func initialize(_ projectId: String, 
                   projectToken: String, 
                   shortLinkDomain: String, 
                   serverUrl: String?, 
                   enableDebugLogging: Bool, 
                   resolver: @escaping RCTPromiseResolveBlock, 
                   rejecter: @escaping RCTPromiseRejectBlock) {
        
        // Initialize your native iOS SDK here
        // This is a placeholder implementation
        DispatchQueue.main.async {
            // Simulate SDK initialization
            print("Initializing TrackingSDK with projectId: \(projectId)")
            
            // Send callback event
            let callbackData: [String: Any] = [
                "callbackType": "initialized",
                "data": "SDK initialized successfully"
            ]
            self.sendEvent(withName: "onSdkCallback", body: callbackData)
            
            resolver("initialized")
        }
    }
    
    @objc
    func onAppResume(_ resolver: @escaping RCTPromiseResolveBlock, 
                     rejecter: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            // Implement app resume tracking
            resolver(nil)
        }
    }
    
    @objc
    func trackAppOpen(_ shortLink: String?, 
                     resolver: @escaping RCTPromiseResolveBlock, 
                     rejecter: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            // Implement app open tracking
            let result = "App open tracked"
            resolver(result)
        }
    }
    
    @objc
    func trackSessionStart(_ shortLink: String?, 
                          resolver: @escaping RCTPromiseResolveBlock, 
                          rejecter: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            // Implement session start tracking
            let result = "Session start tracked"
            resolver(result)
        }
    }
    
    @objc
    func trackShortLinkClick(_ shortLink: String, 
                            deepLink: String?, 
                            resolver: @escaping RCTPromiseResolveBlock, 
                            rejecter: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            // Implement short link click tracking
            let result = "Short link click tracked"
            resolver(result)
        }
    }
    
    @objc
    func getInstallReferrer(_ resolver: @escaping RCTPromiseResolveBlock, 
                           rejecter: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            // Implement get install referrer
            let referrer = "sample_referrer_data"
            resolver(referrer)
        }
    }
    
    @objc
    func fetchInstallReferrer(_ resolver: @escaping RCTPromiseResolveBlock, 
                             rejecter: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            // Implement fetch install referrer
            let referrer = "fetched_referrer_data"
            resolver(referrer)
        }
    }
    
    @objc
    func resetFirstInstall(_ resolver: @escaping RCTPromiseResolveBlock, 
                          rejecter: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            // Implement reset first install
            resolver(nil)
        }
    }
} 