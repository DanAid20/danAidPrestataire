import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyDo_GVP7wHiUoMuXfS-KmfwWr8PAlLZ8Ww")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
