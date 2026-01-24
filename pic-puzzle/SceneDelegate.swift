//
//  SceneDelegate.swift
//  pic-puzzle
//
//  Created by Ossama Abdelwahab on 23/01/26.
//

import UIKit

// MARK: - SceneDelegate

/// Scene delegate managing the app's UI lifecycle and window management
/// Handles scene connection, disconnection, and state transitions
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Properties
    
    /// Main window for the scene displaying the app's UI hierarchy
    var window: UIWindow?
    
    // MARK: - Scene Lifecycle
    
    /// Called when the scene will connect to the session
    /// Sets up the initial view controller hierarchy and window
    /// - Parameters:
    ///   - scene: The scene object being connected
    ///   - session: The session associated with the scene
    ///   - connectionOptions: Options for configuring the scene's initial state
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        // Create window for the scene
        let window = UIWindow(windowScene: windowScene)
        
        // Initialize MVVM architecture: ViewModel -> ViewController
        let viewModel = HomeViewModel()
        let rootVC = HomeViewController(viewModel: viewModel)
        
        // Embed in navigation controller for navigation stack support
        let nav = UINavigationController(rootViewController: rootVC)
        
        // Set root and display window
        window.rootViewController = nav
        window.makeKeyAndVisible()
        self.window = window
    }
    
    /// Called as the scene is being released by the system
    /// Release any resources associated with the scene that can be recreated later
    /// - Parameter scene: The scene being disconnected
    func sceneDidDisconnect(_ scene: UIScene) {
        // Release scene-specific resources here
        // The scene may reconnect later, so don't release resources needed for reconnection
    }
    
    /// Called when the scene has moved from inactive to active state
    /// Use this method to restart tasks that were paused when the scene was inactive
    /// - Parameter scene: The scene that became active
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Restart any paused tasks or refresh UI
    }
    
    /// Called when the scene will move from active to inactive state
    /// Use this method to pause ongoing tasks or reduce frame rates
    /// - Parameter scene: The scene that will become inactive
    func sceneWillResignActive(_ scene: UIScene) {
        // Pause tasks, disable timers, reduce frame rate
    }
    
    /// Called as the scene transitions from background to foreground
    /// Use this method to undo changes made when entering the background
    /// - Parameter scene: The scene entering foreground
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Undo background changes, refresh UI if needed
    }
    
    /// Called as the scene transitions from foreground to background
    /// Use this method to save data and release shared resources
    /// - Parameter scene: The scene entering background
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Save data, release resources, store scene state for restoration
    }
}

