//
//  UIFeedViewPresenterTests.swift
//  FeedUnitTestingTests
//
//  Created by Ahmed Fathy on 03/10/2024.
//

@testable import FeedUnitTesting
import XCTest

final class UIFeedViewPresenterTests: XCTestCase {
  func test_showEmptyState_shouldShowAlert() throws {
    try expect(for: .empty) { sut in
      sut.showEmptyState()
    }
  }

  func test_showLoader_shouldShowAlert() throws {
    try expect(for: .loading) { sut in
      sut.showLoader()
    }
  }

  func test_hideLoader_shouldShowAlert() throws {
    try expect(for: .hidden) { sut in
      sut.hideLoader()
    }
  }

  func test_showError_shouldShowAlert() throws {
    try expect(for: .error) { sut in
      sut.showError(NSError(domain: "any error", code: 0))
    }
  }

  
  func test_showViewController_shouldPresentViewController() {
    let presentedViewController = UIViewController()
    let spy = UIViewControllerSpy()
    let sut = makeSUT(viewController: spy)
    
    sut.show(presentedViewController)
    
    XCTAssertIdentical(presentedViewController, spy.capturedViewController)
  }
  
  
  private func makeSUT(viewController: UIViewController) -> UIFeedViewRouter {
    UIFeedViewRouter(rootViewController: viewController)
  }

  private func expect(
    for state: UIFeedViewRouter.PresenterTitleConstats,
    when action: @escaping (UIFeedViewRouter) -> Void,
    file: StaticString = #filePath,
    line: UInt = #line
  ) throws {
    let spy = UIViewControllerSpy()
    let sut = makeSUT(viewController: spy)
    action(sut)
    let alertVC = try XCTUnwrap(spy.capturedViewController as? UIAlertController)
    XCTAssertEqual(alertVC.title, retriveTitle(state), file: file, line: line)
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
