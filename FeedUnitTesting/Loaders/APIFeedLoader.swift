//
//  APIFeedLoader.swift
//  FeedUnitTesting
//
//  Created by Ahmed Fathy on 30/09/2024.
//

import Foundation

final class APIFeedLoader: FeedLoader {
  private let manager: NetworkManager
  
  init(manager: NetworkManager = .shared) {
    self.manager = manager
  }
  
  func fetchData(completion: @escaping (Result<[FeedItem], any Error>) -> Void) {
    manager.fetchData(
      url: Constants.feedURL,
      completion: completion
    )
  }
}
