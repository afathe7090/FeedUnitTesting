//
//  FeedUnitTestingTests.swift
//  FeedUnitTestingTests
//
//  Created by Ahmed Fathy on 14/09/2024.
//

@testable import FeedUnitTesting
import XCTest

final class FeedUnitTestingTests: XCTestCase {
  func test_whenViewDidLoad_thenTableViewDataSourceIsSet() {
    let sut = makeSUT()

    XCTAssertNotNil(sut.tableView.delegate)
    XCTAssertNotNil(sut.tableView.dataSource)
  }

  func test_whenLoadView_thenFeedItemsIsEmpty() {
    let sut = makeSUT()
    let tableViewCellCount = sut.numberOfRows()

    XCTAssertEqual(sut.feedItems, [])
    XCTAssertEqual(tableViewCellCount, sut.feedItemsCount)
  }

  // mock
  func test_whenLoadView_thenFetchDataShouldLoaded() {
    let spy = FeedLoaderSpy()
    let _ = makeSUT(loader: spy)
    // set data
    XCTAssertEqual(spy.states, [.fetchData])
  }

  func test_whenLoadView_withEmptyFeedsShouldEmptyCells() {
    let spy = FeedLoaderSpy()
    let presenter = FeedViewPresenterSpy()
    let sut = makeSUT(loader: spy, presenter: presenter)

    spy.simulateEmptyState()

    XCTAssertEqual(sut.feedItems, [])
    XCTAssertEqual(sut.numberOfRows(), 0)
    XCTAssertEqual(presenter.states, [.showLoader, .emptyState, .hideLoader])
  }

  func test_whenLoadView_withLoadFeedsShouldRenderCells() {
    let items = makeFeedItems()
    let spy = FeedLoaderSpy()
    let presenter = FeedViewPresenterSpy()
    let sut = makeSUT(loader: spy, presenter: presenter)

    spy.simulateFeedsItems(items)

    XCTAssertEqual(sut.feedItems, items)
    XCTAssertEqual(sut.numberOfRows(), items.count)
    XCTAssertEqual(presenter.states, [.showLoader, .hideLoader])
  }

  func test_whenLoadView_withErrorShouldShowErrorState() {
    let anyError = anyError()
    let spy = FeedLoaderSpy()
    let presenter = FeedViewPresenterSpy()
    let sut = makeSUT(loader: spy, presenter: presenter)

    spy.simulateError(anyError)

    XCTAssertEqual(sut.feedItems, [])
    XCTAssertEqual(sut.numberOfRows(), 0)
    XCTAssertEqual(presenter.states, [.showLoader, .error(AnyError(error: anyError)), .hideLoader])
  }
  
  func test_whenLoadFeeds_withItemsShouldRenderCells() {
    let items = makeFeedItems()
    let spy = FeedLoaderSpy()
    let sut = makeSUT(loader: spy)
    
    spy.simulateFeedsItems(items)
    
    items.enumerated().forEach { index, item in
      let cell = sut.cell(for: index)
      
      XCTAssertEqual(cell?.titleLbl.text, items[index].name)
      XCTAssertEqual(cell?.bodyLbl.text, items[index].email)
    }
  }
  
  
  func test_whenTabOnDidSelectCell_shouldPresentViewController() {
    let items = makeFeedItems()
    let spy = FeedLoaderSpy()
    let presenter = FeedViewPresenterSpy()
    let sut = makeSUT(loader: spy, presenter: presenter)
    
    spy.simulateFeedsItems(items)
    
    XCTAssertEqual(presenter.viewControllers, [])
    
    sut.didSelectCell(0)
    XCTAssertEqual(presenter.viewControllers.count, 1)
    
    sut.didSelectCell(1)
    XCTAssertEqual(presenter.viewControllers.count, 2)
  }

  private func makeSUT(
    loader: FeedLoader = FeedLoaderSpy(),
    presenter: FeedViewRouter = FeedViewPresenterSpy()
  ) -> FeedViewController {
    let sb = UIStoryboard(name: "Main", bundle: nil)
    let viewController = sb.instantiateViewController(identifier: "FeedViewController") { coder in
      FeedViewController(coder: coder, loader: loader, presenter: presenter)
    }
    viewController.loadViewIfNeeded()
    return viewController
  }

  private func makeFeedItems() -> [FeedItem] {
    [
      FeedItem(id: 0, name: "any name 0", email: "any mail 0"),
      FeedItem(id: 1, name: "any name 1", email: "any mail 1")
    ]
  }

  private func anyError() -> Error {
    NSError(domain: "anyError", code: 0)
  }

  private final class FeedViewPresenterSpy: FeedViewRouter {
    enum State: Equatable {
      case emptyState
      case showLoader
      case hideLoader
      case error(AnyError)
    }

    private(set) var states: [State] = []
    private(set) var viewControllers: [UIViewController] = []
    
    func showEmptyState() {
      states.append(.emptyState)
    }

    func showLoader() {
      states.append(.showLoader)
    }

    func hideLoader() {
      states.append(.hideLoader)
    }

    func showError(_ error: any Error) {
      states.append(.error(AnyError(error: error)))
    }
    
    func show(_ viewController: UIViewController) {
      viewControllers.append(viewController)
    }
  }
}
