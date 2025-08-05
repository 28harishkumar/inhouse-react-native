// TrackingSDKModule.swift
import Foundation
import React
import InhouseTrackingSDK

@objc(TrackingSDK)
class TrackingSDKModule: RCTEventEmitter {
    
    override init() {
        super.init()
    }
    
    override func supportedEvents() -> [String]! {
        return ["onSdkCallback"]
    }
    
    override static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    override func constantsToExport() -> [AnyHashable: Any]! {
        return [
            "SDK_VERSION": "1.0.0",
            "PLATFORM": "iOS"
        ]
    }
    
    @objc
    func initialize(_ projectId: String, 
                   projectToken: String, 
                   shortLinkDomain: String, 
                   serverUrl: String?, 
                   enableDebugLogging: Bool, 
                   resolver: @escaping RCTPromiseResolveBlock, 
                   rejecter: @escaping RCTPromiseRejectBlock) {
        
        DispatchQueue.main.async {
            do {
                // Initialize the actual iOS SDK
                let finalServerUrl = serverUrl ?? "https://api.tryinhouse.co"
                
                InhouseTrackingSDK.shared.initialize(
                    projectId: projectId,
                    projectToken: projectToken,
                    shortLinkDomain: shortLinkDomain,
                    serverUrl: finalServerUrl,
                    enableDebugLogging: enableDebugLogging
                ) { [weak self] callbackType, jsonData in
                    // Send callback event
                    let callbackData: [String: Any] = [
                        "callbackType": callbackType,
                        "data": jsonData
                    ]
                    self?.sendEvent(withName: "onSdkCallback", body: callbackData)
                }
                
                resolver("initialized")
            } catch {
                rejecter("INITIALIZATION_ERROR", error.localizedDescription, error)
            }
        }
    }
    
    @objc
    func onAppResume(_ resolver: @escaping RCTPromiseResolveBlock, 
                     rejecter: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            do {
                InhouseTrackingSDK.shared.onAppResume()
                resolver(nil)
            } catch {
                rejecter("APP_RESUME_ERROR", error.localizedDescription, error)
            }
        }
    }
    
    @objc
    func trackAppOpen(_ shortLink: String?, 
                     resolver: @escaping RCTPromiseResolveBlock, 
                     rejecter: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            do {
                InhouseTrackingSDK.shared.trackAppOpen(shortLink: shortLink) { responseJson in
                    resolver(responseJson)
                }
            } catch {
                rejecter("TRACK_APP_OPEN_ERROR", error.localizedDescription, error)
            }
        }
    }
    
    @objc
    func trackSessionStart(_ shortLink: String?, 
                          resolver: @escaping RCTPromiseResolveBlock, 
                          rejecter: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            do {
                InhouseTrackingSDK.shared.trackSessionStart(shortLink: shortLink) { responseJson in
                    resolver(responseJson)
                }
            } catch {
                rejecter("TRACK_SESSION_START_ERROR", error.localizedDescription, error)
            }
        }
    }
    
    @objc
    func trackShortLinkClick(_ shortLink: String, 
                            deepLink: String?, 
                            resolver: @escaping RCTPromiseResolveBlock, 
                            rejecter: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            do {
                InhouseTrackingSDK.shared.trackShortLinkClick(shortLink: shortLink, deepLink: deepLink) { responseJson in
                    resolver(responseJson)
                }
            } catch {
                rejecter("TRACK_SHORT_LINK_CLICK_ERROR", error.localizedDescription, error)
            }
        }
    }
    
    @objc
    func getInstallReferrer(_ resolver: @escaping RCTPromiseResolveBlock, 
                           rejecter: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            do {
                let referrer = InhouseTrackingSDK.shared.getInstallReferrer()
                resolver(referrer)
            } catch {
                rejecter("GET_INSTALL_REFERRER_ERROR", error.localizedDescription, error)
            }
        }
    }
    
    @objc
    func fetchInstallReferrer(_ resolver: @escaping RCTPromiseResolveBlock, 
                             rejecter: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            do {
                InhouseTrackingSDK.shared.fetchInstallReferrer { referrer in
                    resolver(referrer)
                }
            } catch {
                rejecter("FETCH_INSTALL_REFERRER_ERROR", error.localizedDescription, error)
            }
        }
    }
    
    @objc
    func resetFirstInstall(_ resolver: @escaping RCTPromiseResolveBlock, 
                          rejecter: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            do {
                InhouseTrackingSDK.shared.resetFirstInstall()
                resolver(nil)
            } catch {
                rejecter("RESET_FIRST_INSTALL_ERROR", error.localizedDescription, error)
            }
        }
    }
}

// MARK: - RCTBridgeModule
extension TrackingSDKModule: RCTBridgeModule {
    static func moduleName() -> String! {
        return "TrackingSDK"
    }
}