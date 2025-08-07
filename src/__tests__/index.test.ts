import TrackingSDK from "../index";

// Mock React Native modules
jest.mock("react-native", () => ({
  NativeModules: {
    TrackingSDK: {
      initialize: jest.fn(),
      onAppResume: jest.fn(),
      trackAppOpen: jest.fn(),
      trackSessionStart: jest.fn(),
      trackShortLinkClick: jest.fn(),
      getInstallReferrer: jest.fn(),
      fetchInstallReferrer: jest.fn(),
      resetFirstInstall: jest.fn(),
    },
  },
  NativeEventEmitter: jest.fn().mockImplementation(() => ({
    addListener: jest.fn().mockReturnValue({
      remove: jest.fn(),
    }),
  })),
}));

describe("TrackingSDK", () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it("should be defined", () => {
    expect(TrackingSDK).toBeDefined();
  });

  it("should have all required methods", () => {
    expect(typeof TrackingSDK?.initialize).toBe("function");
    expect(typeof TrackingSDK?.onAppResume).toBe("function");
    expect(typeof TrackingSDK?.trackAppOpen).toBe("function");
    expect(typeof TrackingSDK?.trackSessionStart).toBe("function");
    expect(typeof TrackingSDK?.trackShortLinkClick).toBe("function");
    expect(typeof TrackingSDK?.getInstallReferrer).toBe("function");
    expect(typeof TrackingSDK?.fetchInstallReferrer).toBe("function");
    expect(typeof TrackingSDK?.resetFirstInstall).toBe("function");
    expect(typeof TrackingSDK?.addCallbackListener).toBe("function");
    expect(typeof TrackingSDK?.removeCallbackListener).toBe("function");
    expect(typeof TrackingSDK?.removeAllListeners).toBe("function");
  });
});
