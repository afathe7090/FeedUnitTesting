//
//  SceneDelegate.swift
//  FeedUnitTesting
//
//  Created by Ahmed Fathy on 14/09/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let scene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: scene)
    window?.rootViewController = makeRootViewController()
    window?.makeKeyAndVisible()
  }

  private func makeRootViewController() -> UIViewController {
    let sb = UIStoryboard(name: "Main", bundle: nil)
    let viewController = sb.instantiateViewController(identifier: "FeedViewController") { coder in
      FeedViewController(coder: coder, loader: APIFeedLoader(), presenter: UIFeedViewRouter())
    }
    return UINavigationController(rootViewController: viewController)
  }
}

