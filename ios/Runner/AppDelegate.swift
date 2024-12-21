import UIKit
import Flutter
import GoogleMaps
import flutter_local_notifications


@main
@objc class AppDelegate: FlutterAppDelegate {
var field = UITextField()
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

  override func applicationWillResignActive(_ application: UIApplication){
    field.isSecureTextEntry = false
  }

  override func applicationDidBecomeActive(_ application: UIApplication){
      field.isSecureTextEntry = true
  }

  private func addSecureView(){
    if(!window.subviews.contains(field)){
        window.addSubview(field)
        field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
        field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
        window.layer.superlayer?.addSublayer(field.layer)
        if #available(iOS 17.0, *){
            field.layer.sublayers?.last?.addSublayer(window.layer)
        }else{
            field.layer.sublayers?.first?.addSublayer(window.layer)
        }
    }
  }

  func removeSecureView() {

      guard let window = UIApplication.shared.windows.first(where: \.isKeyWindow) else { return }

      if field.isDescendant(of: window) {
          print("myNewView isDescendant of window")
      }

      for view in window.subviews as [UIView] where view == field {
          view.removeFromSuperview()
          break
      }

      if field.isDescendant(of: window) {
          print("myNewView isDescendant of window")
      } else {
          print("myNewView is REMOVED from window") // THIS WILL PRINT
      }
  }

   private func setSecureScreen(_ secure: Bool) {
     if secure {
        field.isSecureTextEntry = true
       addSecureView()
       NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(handleApplicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
     } else {
       field.isSecureTextEntry = false
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

