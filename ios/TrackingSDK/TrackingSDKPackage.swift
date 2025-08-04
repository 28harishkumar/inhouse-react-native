import Foundation
import React

@objc(TrackingSDKPackage)
class TrackingSDKPackage: NSObject, RCTPackage {
    
    func moduleForName(_ moduleName: String!) -> Any! {
        return TrackingSDK()
    }
    
    func moduleNames() -> [String]! {
        return ["TrackingSDK"]
    }
} 