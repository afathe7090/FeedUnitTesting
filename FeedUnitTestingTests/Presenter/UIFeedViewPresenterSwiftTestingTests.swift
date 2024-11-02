//
//  UIFeedViewPresenterTests.swift
//  FeedUnitTestingTests
//
//  Created by Ahmed Fathy on 03/10/2024.
//

@testable import FeedUnitTesting
import Testing
import UIKit

extension Tag {
  @Tag static var errorHandling: Self
}


@MainActor
@Suite("UIFeedViewPresenterSwiftTesting File 🥳")
struct UIFeedViewPresenterSwiftTesting {
    
  @Test
  func showEmptyState_shouldShowAlert() throws {
    try expect(for: .empty) { sut in
      sut.showEmptyState()
    }
  }
  
  @Test
  func showLoader_shouldShowAlert() throws {
    try expect(for: .loading) { sut in
      sut.showLoader()
    }
  }

  @Test(.tags(.errorHandling))
  func hideLoader_shouldShowAlert() throws {
    try expect(for: .hidden) { sut in
      sut.hideLoader()
    }
  }
  
  @Test(.tags(.errorHandling))
  func showError_shouldShowAlert() throws {
    try expect(for: .error) { sut in
      sut.showError(NSError(domain: "any error", code: 0))
    }
  }

  @Test
  func showViewController_shouldPresentViewController() {
    let presentedViewController = UIViewController()
  
    let spy = UIViewControllerSpy()
    let sut = makeSUT(viewController: spy)
    
    sut.show(presentedViewController)
    
    #expect(presentedViewController === spy.capturedViewController)
  }
  
  
  private func makeSUT(viewController: UIViewController) -> UIFeedViewRouter {
    UIFeedViewRouter(rootViewController: viewController)
  }

  private func expect(
    for state: UIFeedViewRouter.PresenterTitleConstats,
    when action: @escaping (UIFeedViewRouter) -> Void,
    sourceLocation: SourceLocation = #_sourceLocation
  ) throws {
    let spy = UIViewControllerSpy()
    let sut = makeSUT(viewController: spy)
    action(sut)
    let alertVC = try #require(spy.capturedViewController as? UIAlertController)
    
    #expect(alertVC.title == retriveTitle(state), sourceLocation: sourceLocation)
  }

  private func retriveTitle(
    _ state: UIFeedViewRouter.PresenterTitleConstats
  ) -> String {
    state.rawValue
  }

  private class UIViewControllerSpy: UIViewController {
    private(set) var capturedViewController: UIViewController?

    override func present(
      _ viewControllerToPresent: UIViewController,
      animated flag: Bool,
      completion: (() -> Void)? = nil
    ) {
      capturedViewController = viewControllerToPresent
    }
  }
}
