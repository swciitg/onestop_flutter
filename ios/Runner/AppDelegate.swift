import UIKit
import Flutter
import GoogleMaps
import flutter_local_notifications


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private var blurEffectView: UIVisualEffectView?
  private let SCREENSHOT_CHANNEL = "com.example.app/screenshot"
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let screenshotChannel = FlutterMethodChannel(name: SCREENSHOT_CHANNEL, binaryMessenger: controller.binaryMessenger)

    screenshotChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
       if call.method == "preventScreenshots", let secure = call.arguments as? Bool {
         self.setSecureScreen(secure)
         result(nil)
       } else {
         result(FlutterMethodNotImplemented)
       }
     }

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

 @objc private func userDidTakeScreenshot() {
     if let window = UIApplication.shared.keyWindow {
       addBlurEffect(to: window)
       DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
         self.removeBlurEffect()
       }
     }
   }

   private func setSecureScreen(_ secure: Bool) {
     if secure {
       NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
     } else {
       NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
       NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
     }
   }

   @objc private func handleApplicationWillResignActive(_ notification: Notification) {
     if let window = UIApplication.shared.keyWindow {
       addBlurEffect(to: window)
     }
   }

   @objc private func handleApplicationDidBecomeActive(_ notification: Notification) {
     removeBlurEffect()
   }

   private func addBlurEffect(to window: UIWindow) {
     let blurEffect = UIBlurEffect(style: .dark)
     let blurEffectView = UIVisualEffectView(effect: blurEffect)
     blurEffectView.frame = window.bounds
     blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
     blurEffectView.tag = 999
     window.addSubview(blurEffectView)
     self.blurEffectView = blurEffectView
   }

   private func removeBlurEffect() {
     blurEffectView?.removeFromSuperview()
     blurEffectView = nil
   }
}

