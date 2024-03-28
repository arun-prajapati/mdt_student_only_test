import UIKit
import Flutter
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
// import UIKit
// import Flutter
//
// @UIApplicationMain
// class AppDelegate: UIResponder, UIApplicationDelegate {
// func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
// ) -> Bool {
//     ApplicationDelegate.shared.application(
//                 app,
//                 open: url,
//                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//                 annotation: options[UIApplication.OpenURLOptionsKey.annotation]
//             )
//
//     return true
// }
//
//     func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
//         guard let url = URLContexts.first?.url else {
//             return
//         }
//
//         ApplicationDelegate.shared.application(
//             UIApplication.shared,
//             open: url,
//             sourceApplication: nil,
//             annotation: [UIApplication.OpenURLOptionsKey.annotation]
//         )
//     }
//
// }
