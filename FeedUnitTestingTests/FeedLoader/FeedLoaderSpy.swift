//
//  FeedLoaderSpy.swift
//  FeedUnitTesting
//
//  Created by Ahmed Fathy on 03/10/2024.
//

@testable import FeedUnitTesting
import Foundation

final class FeedLoaderSpy: FeedLoader {
  enum State {
    case fetchData
    case storeData
  }
  
  private(set) var states: [State] = []
  // Block of action from viewController
  private var completion: ((Result<[FeedItem], any Error>) -> Void)?
  
  func fetchData(completion: @escaping (Result<[FeedItem], any Error>) -> Void) {
    states.append(.fetchData)
    self.completion = completion
  }
  
  // empty state
  func simulateEmptyState() {
    completion?(.success([]))
  }
  
  // any feeds
  func simulateFeedsItems(_ feeds: [FeedItem]) {
    completion?(.success(feeds))
  }
  
  // error
  func simulateError(_ error: Error) {
    completion?(.failure(error))
  }
}
