//
//  SceneDelegate.swift
//  Visitor
//
//  Created by 이승기 on 3/16/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let scene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: scene)
    window.rootViewController = ViewController()
    window.makeKeyAndVisible()
    self.window = window
  }
}

