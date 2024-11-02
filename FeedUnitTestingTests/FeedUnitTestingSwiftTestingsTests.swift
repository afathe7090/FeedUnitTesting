//
//  FeedUnitTestingTests.swift
//  FeedUnitTestingTests
//
//  Created by Ahmed Fathy on 14/09/2024.
//

@testable import FeedUnitTesting
import UIKit
import Testing

@MainActor
@Suite("FeedUnitTestingSwiftTestingsTests 🚀")
struct FeedUnitTestingSwiftTestingsTests {
    
  @Test
  func test_whenViewDidLoad_thenTableViewDataSourceIsSet() {
    let sut = makeSUT()

    #expect(sut.tableView.delegate != nil)
    #expect(sut.tableView.dataSource != nil)
  }
  
  @Test
  func test_whenLoadView_thenFeedItemsIsEmpty() {
    let sut = makeSUT()
    let tableViewCellCount = sut.numberOfRows()

    #expect(sut.feedItems == [])
    #expect(tableViewCellCount == sut.feedItemsCount)
  }

  @Test
  func test_whenLoadView_thenFetchDataShouldLoaded() {
    let spy = FeedLoaderSpy()
    let _ = makeSUT(loader: spy)
    // set data
    #expect(spy.states == [.fetchData])
  }

  @Test
  func test_whenLoadView_withEmptyFeedsShouldEmptyCells() {
    let spy = FeedLoaderSpy()
    let presenter = FeedViewPresenterSpy()
    let sut = makeSUT(loader: spy, presenter: presenter)

    spy.simulateEmptyState()

    #expect(sut.feedItems == [])
    #expect(sut.numberOfRows() == 0)

    #expect(presenter.states == [.showLoader, .emptyState, .hideLoader])
  }
  @Test
  func test_whenLoadView_withLoadFeedsShouldRenderCells() {
    let items = makeFeedItems()
    let spy = FeedLoaderSpy()
    let presenter = FeedViewPresenterSpy()
    let sut = makeSUT(loader: spy, presenter: presenter)

    spy.simulateFeedsItems(items)

    
    #expect(sut.feedItems == items)
    #expect(sut.numberOfRows() == items.count)
    #expect(presenter.states == [.showLoader, .hideLoader])
  }
  @Test
  func test_whenLoadView_withErrorShouldShowErrorState() {
    let anyError = anyError()
    let spy = FeedLoaderSpy()
    let presenter = FeedViewPresenterSpy()
    let sut = makeSUT(loader: spy, presenter: presenter)

    spy.simulateError(anyError)

    #expect(sut.feedItems == [])
    #expect(sut.numberOfRows() == 0)
    #expect(presenter.states == [.showLoader, .error(AnyError(error: anyError)), .hideLoader])
  }
  
  @Test
  func test_whenLoadFeeds_withItemsShouldRenderCells() {
    let items = makeFeedItems()
    let spy = FeedLoaderSpy()
    let sut = makeSUT(loader: spy)
    
    spy.simulateFeedsItems(items)
    
    items.enumerated().forEach { index, item in
      let cell = sut.cell(for: index)
      
      #expect(cell?.titleLbl.text == items[index].name)
      #expect(cell?.bodyLbl.text == items[index].email)
    }
  }
  
  @Test
  func test_whenTabOnDidSelectCell_shouldPresentViewController() {
    let items = makeFeedItems()
    let spy = FeedLoaderSpy()
    let presenter = FeedViewPresenterSpy()
    let sut = makeSUT(loader: spy, presenter: presenter)
    
    spy.simulateFeedsItems(items)
    
    #expect(presenter.viewControllers == [])
    
    sut.didSelectCell(0)
    #expect(presenter.viewControllers.count == 1)
    
    sut.didSelectCell(1)
    #expect(presenter.viewControllers.count == 2)
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
