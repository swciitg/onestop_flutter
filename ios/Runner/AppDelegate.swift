import UIKit
import Flutter
import GoogleMaps
import flutter_local_notifications


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
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
}

