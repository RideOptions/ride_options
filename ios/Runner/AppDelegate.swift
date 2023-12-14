import UIKit
import Flutter
import GoogleMaps
import google_maps_flutter_ios

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GMSServices.provideAPIKey("AIzaSyAfEmRNgujuOf8AycNcScqCMkk6LWgP1IQ")
//      GMSPlacesClient.provideAPIKey("AIzaSyCjxRhtdw74nJ9YdYaGjvY5IZUEA5Ux0JA")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
