package co.tryinhouse.react_native

import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.WritableMap
import com.facebook.react.bridge.Arguments
import com.facebook.react.modules.core.DeviceEventManagerModule
import co.tryinhouse.android.TrackingSDK
import android.util.Log
import android.app.Activity
import android.os.Handler
import android.os.Looper
import com.google.gson.Gson
import com.thumbmarkjs.thumbmark_android.Thumbmark

class TrackingSDKModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    override fun getName(): String = "TrackingSDK"

    @ReactMethod
    fun initialize(
        projectToken: String,
        tokenId: String,
        shortLinkDomain: String,
        serverUrl: String?,
        enableDebugLogging: Boolean,
        promise: Promise
    ) {
        try {
            Log.d("TrackingSDKModule", "initialize called with projectToken=$projectToken, tokenId=$tokenId, shortLinkDomain=$shortLinkDomain, serverUrl=$serverUrl, enableDebugLogging=$enableDebugLogging")
            
            TrackingSDK.getInstance().initialize(
                context = reactApplicationContext,
                projectToken = projectToken,
                tokenId = tokenId,
                shortLinkDomain = shortLinkDomain,
                serverUrl = serverUrl ?: "https://api.tryinhouse.co",
                enableDebugLogging = enableDebugLogging
            ) { callbackType, jsonData ->
                Log.d("TrackingSDKModule", "SDK callback: callbackType=$callbackType, data=$jsonData")
                val params = Arguments.createMap().apply {
                    putString("callbackType", callbackType)
                    putString("data", jsonData)
                }
                Handler(Looper.getMainLooper()).post {
                    reactApplicationContext
                        .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
                        .emit("onSdkCallback", params)
                }
            }
            promise.resolve("initialized")
        } catch (e: Exception) {
            Log.e("TrackingSDKModule", "Initialization error", e)
            promise.reject("INITIALIZATION_ERROR", e.message, e)
        }
    }

    @ReactMethod
    fun onAppResume(promise: Promise) {
        try {
            TrackingSDK.getInstance().onAppResume()
            promise.resolve(null)
        } catch (e: Exception) {
            promise.reject("APP_RESUME_ERROR", e.message, e)
        }
    }

    @ReactMethod
    fun trackAppOpen(shortLink: String?, promise: Promise) {
        try {
            TrackingSDK.getInstance().trackAppOpen(shortLink) { responseJson ->
                promise.resolve(responseJson)
            }
        } catch (e: Exception) {
            promise.reject("TRACK_APP_OPEN_ERROR", e.message, e)
        }
    }

    @ReactMethod
    fun trackSessionStart(shortLink: String?, promise: Promise) {
        try {
            TrackingSDK.getInstance().trackSessionStart(shortLink) { responseJson ->
                promise.resolve(responseJson)
            }
        } catch (e: Exception) {
            promise.reject("TRACK_SESSION_START_ERROR", e.message, e)
        }
    }

    @ReactMethod
    fun trackShortLinkClick(shortLink: String, deepLink: String?, promise: Promise) {
        try {
            if (shortLink != null) {
                TrackingSDK.getInstance().trackShortLinkClick(shortLink, deepLink) { responseJson ->
                    promise.resolve(responseJson)
                }
            } else {
                promise.resolve(null)
            }
        } catch (e: Exception) {
            promise.reject("TRACK_SHORT_LINK_CLICK_ERROR", e.message, e)
        }
    }

    @ReactMethod
    fun getInstallReferrer(promise: Promise) {
        try {
            val referrer = TrackingSDK.getInstance().getInstallReferrer()
            promise.resolve(referrer)
        } catch (e: Exception) {
            promise.reject("GET_INSTALL_REFERRER_ERROR", e.message, e)
        }
    }

    @ReactMethod
    fun fetchInstallReferrer(promise: Promise) {
        try {
            TrackingSDK.getInstance().fetchInstallReferrer { referrer ->
                Handler(Looper.getMainLooper()).post {
                    promise.resolve(referrer)
                }
            }
        } catch (e: Exception) {
            promise.reject("FETCH_INSTALL_REFERRER_ERROR", e.message, e)
        }
    }

    @ReactMethod
    fun resetFirstInstall(promise: Promise) {
        try {
            TrackingSDK.getInstance().resetFirstInstall()
            promise.resolve(null)
        } catch (e: Exception) {
            promise.reject("RESET_FIRST_INSTALL_ERROR", e.message, e)
        }
    }

    // Expose Thumbmark fingerprint as JSON string
    @ReactMethod
    fun getFingerprint(promise: Promise) {
        try {
            val fingerprint = Thumbmark.fingerprint(reactApplicationContext)
            val json = Gson().toJson(fingerprint)
            promise.resolve(json)
        } catch (e: Exception) {
            Log.e("TrackingSDKModule", "Error getting fingerprint", e)
            promise.reject("GET_FINGERPRINT_ERROR", e.message, e)
        }
    }

    // Expose Thumbmark hashed identifier; optional algorithm parameter
    @ReactMethod
    fun getFingerprintId(algorithm: String?, promise: Promise) {
        try {
            val id = if (algorithm != null && algorithm.isNotEmpty()) {
                Thumbmark.id(reactApplicationContext, algorithm)
            } else {
                Thumbmark.id(reactApplicationContext)
            }
            promise.resolve(id)
        } catch (e: Exception) {
            Log.e("TrackingSDKModule", "Error getting fingerprint id", e)
            promise.reject("GET_FINGERPRINT_ID_ERROR", e.message, e)
        }
    }

    fun setCurrentActivity(activity: Activity?) {
        try {
            TrackingSDK.getInstance().setCurrentActivity(activity)
        } catch (e: Exception) {
            Log.e("TrackingSDKModule", "Error setting current activity", e)
        }
    }
} 