//
//  AppDelegate.swift
//  Usiqee
//
//  Created by Quentin Gallois on 19/10/2020.
//

import UIKit
import Firebase
import Wormholy
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupFirebase()
        setUpWormholy()
        return true
    }
    
    func setupFirebase() {
        FirebaseApp.configure()
        Auth.auth().useAppLanguage()
    }
    
    func setUpWormholy() {
        Wormholy.shakeEnabled = Config.WormholyIsEnabled
    }
    
    // MARK: - DeepLink
    func application(_ application: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:] ) -> Bool {
        if let scheme = url.scheme, scheme.localizedCaseInsensitiveCompare("usiqee") == .orderedSame {
            ManagerDeepLink.shared.setDeeplinkFromDeepLink(url: url)
            HelperRouting.shared.redirect()
        } else {
            return GIDSignIn.sharedInstance.handle(url)
        }
        return false
    }
}

// MARK: - Notification
extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        ServiceDeviceToken.shared.register()
    }
    
    func registerForPushNotifications() {
        let center  = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.sound, .alert, .badge]) { granted, error in
            guard granted, error == nil else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func unregisterForRemoteNotifications() {
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let info = userInfo as? [String: Any] else { return }
        
        ManagerDeepLink.shared.setDeeplinkFromNotification(info: info)
        if application.applicationState != .inactive {
            HelperRouting.shared.redirect()
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
}
