import UIKit
import Flutter
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
               UNUserNotificationCenter.current().delegate = self
           } else {
               // Fallback on earlier versions
           }

            //SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
        // This method will be called when app received push notifications in foreground
        
        @available(iOS 10.0, *)
        override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
        {
            completionHandler([.alert, .badge, .sound])
        }
}
