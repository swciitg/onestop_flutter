import UIKit
import Flutter
import GoogleMaps
import flutter_local_notifications


@main
@objc class AppDelegate: FlutterAppDelegate {
  private var secureField: UITextField?
  private var isSecureMode = false
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
        UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
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
    // App icon switching channel
    let iconChannel = FlutterMethodChannel(name: "com.swciitg.onestop2/app_icon", binaryMessenger: controller.binaryMessenger)
    iconChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "setAlternateIcon", let iconName = call.arguments as? String {
        if UIApplication.shared.supportsAlternateIcons {
          UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error = error {
              result(FlutterError(code: "ICON_ERROR", message: error.localizedDescription, details: nil))
            } else {
              result(nil)
            }
          }
        } else {
          result(FlutterError(code: "NOT_SUPPORTED", message: "Alternate icons not supported", details: nil))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // MARK: - Screenshot Prevention
  // Uses a secure UITextField overlay to prevent screen capture.
  // IMPORTANT: Never reparent window.layer — doing so creates a circular
  // CALayer hierarchy that causes infinite recursion (stack overflow) when
  // UIKit propagates trait-collection changes through the view tree.

  private func setSecureScreen(_ secure: Bool) {
    if secure {
      addSecureView()
      isSecureMode = true
    } else {
      removeSecureView()
      isSecureMode = false
    }
  }

  private func addSecureView() {
    guard let window = window else { return }
    if secureField != nil { return }

    let field = UITextField()
    field.isSecureTextEntry = true
    field.isUserInteractionEnabled = false
    field.translatesAutoresizingMaskIntoConstraints = false
    window.addSubview(field)
    window.sendSubviewToBack(field)
    NSLayoutConstraint.activate([
      field.topAnchor.constraint(equalTo: window.topAnchor),
      field.bottomAnchor.constraint(equalTo: window.bottomAnchor),
      field.leadingAnchor.constraint(equalTo: window.leadingAnchor),
      field.trailingAnchor.constraint(equalTo: window.trailingAnchor),
    ])
    secureField = field
  }

  private func removeSecureView() {
    secureField?.removeFromSuperview()
    secureField = nil
  }

  override func applicationWillResignActive(_ application: UIApplication) {
    if isSecureMode {
      secureField?.isSecureTextEntry = false
    }
    if let window = UIApplication.shared.keyWindow {
      addBlurEffect(to: window)
    }
  }

  override func applicationDidBecomeActive(_ application: UIApplication) {
    if isSecureMode {
      secureField?.isSecureTextEntry = true
    }
    removeBlurEffect()
  }

  // MARK: - Blur Effect (app switcher privacy)

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

