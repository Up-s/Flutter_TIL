import UIKit
import Flutter
import GoogleMaps
import flutter_config

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    if let googleMapKey = FlutterConfigPlugin.env(for: "google_map_key") {
      GMSServices.provideAPIKey(googleMapKey)
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
