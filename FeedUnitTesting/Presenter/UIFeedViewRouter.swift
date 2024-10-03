//
//  UIFeedViewPresenter.swift
//  FeedUnitTesting
//
//  Created by Ahmed Fathy on 03/10/2024.
//

import UIKit

final class UIFeedViewRouter: FeedViewRouter {
  private let rootViewController: UIViewController
  init(rootViewController: UIViewController = UIViewController()) {
    self.rootViewController = rootViewController
  }

  enum PresenterTitleConstats: String {
    case empty
    case loading
    case hidden
    case error
  }
  
  func showEmptyState() {
    let alertController = UIAlertController()
    alertController.title = PresenterTitleConstats.empty.rawValue
    rootViewController.present(alertController, animated: false)
  }

  func showLoader() {
    let alertController = UIAlertController()
    alertController.title = PresenterTitleConstats.loading.rawValue
    rootViewController.present(alertController, animated: false)
  }

  func hideLoader() {
    let alertController = UIAlertController()
    alertController.title = PresenterTitleConstats.hidden.rawValue
    rootViewController.present(alertController, animated: false)
  }

  func showError(_ error: Error) {
    let alertController = UIAlertController()
    alertController.title = PresenterTitleConstats.error.rawValue
    rootViewController.present(alertController, animated: false)
  }
  
  func show(_ viewController: UIViewController) {
    rootViewController.present(viewController, animated: true)
  }
}
