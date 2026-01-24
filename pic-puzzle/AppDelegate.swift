//
//  AppDelegate.swift
//  pic-puzzle
//
//  Created by Ossama Abdelwahab on 23/01/26.
//

import UIKit

// MARK: - AppDelegate

/// Main application delegate handling app lifecycle events
/// Entry point for the iOS application using @main attribute
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Application Lifecycle
    
    /// Called when the application finishes launching
    /// Use this method to initialize app-wide configurations, services, or third-party SDKs
    /// - Parameters:
    ///   - application: The singleton application instance
    ///   - launchOptions: Dictionary indicating the reason the app was launched (if any)
    /// - Returns: False to prevent launch, true to proceed normally
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch
        return true
    }
    
    // MARK: - UISceneSession Lifecycle
    
    /// Called when a new scene session is being created
    /// Use this method to select a configuration to create the new scene with
    /// - Parameters:
    ///   - application: The singleton application instance
    ///   - connectingSceneSession: The session being connected
    ///   - options: Connection options containing scene-specific information
    /// - Returns: The configuration to use for the new scene
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Return default configuration for the scene session
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    /// Called when the user discards a scene session
    /// Use this method to release any resources specific to the discarded scenes
    /// - Parameters:
    ///   - application: The singleton application instance
    ///   - sceneSessions: Set of scene sessions being discarded
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Release resources associated with discarded scenes
        // Called when user closes scenes in multitasking or when scenes are discarded while app not running
    }
}
