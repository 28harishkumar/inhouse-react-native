import {
  NativeModules,
  NativeEventEmitter,
  EmitterSubscription,
  Platform,
} from "react-native";

const { TrackingSDK } = NativeModules;

// Check if the native module is available
if (!TrackingSDK) {
  console.error(
    "TrackingSDK native module is not available. Make sure the native module is properly linked."
  );
}

export interface TrackingSDKCallback {
  callbackType: string;
  data: string;
}

export interface TrackingSDKInterface {
  initialize(
    projectId: string,
    projectToken: string,
    shortLinkDomain: string,
    serverUrl?: string,
    enableDebugLogging?: boolean
  ): Promise<string>;

  onAppResume(): Promise<void>;

  onNewURL(url: string): Promise<void>;

  trackAppOpen(shortLink?: string): Promise<string>;

  trackSessionStart(shortLink?: string): Promise<string>;

  trackShortLinkClick(shortLink: string, deepLink?: string): Promise<string>;

  getInstallReferrer(): Promise<string>;

  fetchInstallReferrer(): Promise<string>;

  resetFirstInstall(): Promise<void>;

  addCallbackListener(
    callback: (data: TrackingSDKCallback) => void
  ): EmitterSubscription;

  removeCallbackListener(subscription: EmitterSubscription): void;

  removeAllListeners(): void;
}

class TrackingSDKManager implements TrackingSDKInterface {
  private eventEmitter: NativeEventEmitter | null = null;
  private listeners: EmitterSubscription[] = [];
  private isAvailable: boolean = false;

  constructor() {
    if (!TrackingSDK) {
      console.error(
        "TrackingSDK native module is not available. Make sure the native module is properly linked."
      );
      this.isAvailable = false;
      return;
    }

    try {
      // Only create NativeEventEmitter if the module is available
      this.eventEmitter = new NativeEventEmitter(TrackingSDK);
      this.isAvailable = true;
    } catch (error) {
      console.error(
        "Failed to create NativeEventEmitter for TrackingSDK:",
        error
      );
      this.isAvailable = false;
    }
  }

  private checkAvailability(): void {
    if (!this.isAvailable) {
      throw new Error(
        "TrackingSDK native module is not available. Make sure the native module is properly linked."
      );
    }
  }

  initialize(
    projectId: string,
    projectToken: string,
    shortLinkDomain: string,
    serverUrl?: string,
    enableDebugLogging: boolean = false
  ): Promise<string> {
    this.checkAvailability();
    return TrackingSDK.initialize(
      projectId,
      projectToken,
      shortLinkDomain,
      serverUrl,
      enableDebugLogging
    );
  }

  onAppResume(): Promise<void> {
    this.checkAvailability();
    return TrackingSDK.onAppResume();
  }

  onNewURL(url: string): Promise<void> {
    this.checkAvailability();

    if (Platform.OS === "ios") {
      return TrackingSDK.onNewURL(url);
    }

    return Promise.resolve();
  }

  trackAppOpen(shortLink?: string): Promise<string> {
    this.checkAvailability();
    return TrackingSDK.trackAppOpen(shortLink);
  }

  trackSessionStart(shortLink?: string): Promise<string> {
    this.checkAvailability();
    return TrackingSDK.trackSessionStart(shortLink);
  }

  trackShortLinkClick(shortLink: string, deepLink?: string): Promise<string> {
    this.checkAvailability();
    return TrackingSDK.trackShortLinkClick(shortLink, deepLink);
  }

  getInstallReferrer(): Promise<string> {
    this.checkAvailability();
    return TrackingSDK.getInstallReferrer();
  }

  fetchInstallReferrer(): Promise<string> {
    this.checkAvailability();
    return TrackingSDK.fetchInstallReferrer();
  }

  resetFirstInstall(): Promise<void> {
    this.checkAvailability();
    return TrackingSDK.resetFirstInstall();
  }

  addCallbackListener(
    callback: (data: TrackingSDKCallback) => void
  ): EmitterSubscription {
    this.checkAvailability();
    if (!this.eventEmitter) {
      throw new Error("Event emitter is not available");
    }
    const subscription = this.eventEmitter.addListener(
      "onSdkCallback",
      callback
    );
    this.listeners.push(subscription);
    return subscription;
  }

  removeCallbackListener(subscription: EmitterSubscription): void {
    subscription.remove();
    const index = this.listeners.indexOf(subscription);
    if (index > -1) {
      this.listeners.splice(index, 1);
    }
  }

  removeAllListeners(): void {
    this.listeners.forEach((subscription) => subscription.remove());
    this.listeners = [];
  }
}

// Create a singleton instance with proper error handling
let trackingSDKInstance: TrackingSDKManager | null = null;

try {
  trackingSDKInstance = new TrackingSDKManager();
} catch (error) {
  console.error("Failed to initialize TrackingSDK:", error);
}

export default trackingSDKInstance;
