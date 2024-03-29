//
//  SceneDelegate.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 16/01/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        window.overrideUserInterfaceStyle = .dark
        let rootController = CharactersController(nextPage: CharactersModelInfo(next: MortyManager.charcterURL))
        window.rootViewController = UINavigationController(rootViewController: rootController)
        setupNavigationBar()
        
        self.window = window
        window.makeKeyAndVisible()
    }
    
    private func setupNavigationBar() {
        UINavigationBar.appearance().tintColor = .white
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(
            UIOffset(horizontal: -1000.0, vertical: 0.0), for: .default
        )
    }
}

