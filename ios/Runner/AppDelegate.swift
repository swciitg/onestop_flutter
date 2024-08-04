import UIKit
import Flutter
import GoogleMaps
import flutter_local_notifications


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private let SCREENSHOT_CHANNEL = "com.example.app/screenshot"
  private var snapshotView: UIView?
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let screenshotChannel = FlutterMethodChannel(name: SCREENSHOT_CHANNEL, binaryMessenger: controller.binaryMessenger)

    screenshotChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      guard call.method == "preventScreenshots" else {
        result(FlutterMethodNotImplemented)
        return
      }
      self?.preventScreenshots(enabled: call.arguments as? Bool ?? false)
      result(nil)
    })
    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
        GeneratedPluginRegistrant.register(with: registry)
    }
    let dartDefinesString = Bundle.main.infoDictionary!["DART_DEFINES"] as! String
    var dartDefinesDictionary = [String:String]()
    for definedValue in dartDefinesString.components(separatedBy: ",") {
        let decoded = String(data: Data(base64Encoded: definedValue)!, encoding: .utf8)!
        let values = decoded.components(separatedBy: "=")
        dartDefinesDictionary[values[0]] = values[1]
    }
    GMSServices.provideAPIKey(dartDefinesDictionary["GMAP_KEY"] as? String ?? "")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  private func preventScreenshots(enabled: Bool) {
    if enabled {
      NotificationCenter.default.removeObserver(
          self,
          name: UIApplication.userDidTakeScreenshotNotification,
          object: nil
      )
    } else {
      NotificationCenter.default.addObserver(
          self,
          selector: #selector(didTakeScreenshot),
          name: UIApplication.userDidTakeScreenshotNotification,
          object: nil
      )
    }
  }

  @objc private func didTakeScreenshot() {
    guard let window = self.window else { return }
      // Add a blur effect view to hide sensitive information
      let blurEffect = UIBlurEffect(style: .light)
      let blurEffectView = UIVisualEffectView(effect: blurEffect)
      blurEffectView.frame = window.bounds
      window.addSubview(blurEffectView)

      // Store the blur effect view in a property so it can be removed later
      self.blurEffectView = blurEffectView

      // Optionally remove the blur effect after some delay
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        blurEffectView.removeFromSuperview()
        self.blurEffectView = nil
      }
  }
}

