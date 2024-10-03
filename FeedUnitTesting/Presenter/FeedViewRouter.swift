//
//  FeedViewPresenter.swift
//  FeedUnitTesting
//
//  Created by Ahmed Fathy on 03/10/2024.
//

import UIKit

protocol FeedViewRouter {
  func showEmptyState()
  func showLoader()
  func hideLoader()
  func showError(_ error: any Error)
  
  func show(_ viewController: UIViewController)
}
