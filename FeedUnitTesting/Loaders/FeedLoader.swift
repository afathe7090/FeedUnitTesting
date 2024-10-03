//
//  FeedLoader.swift
//  FeedUnitTesting
//
//  Created by Ahmed Fathy on 30/09/2024.
//

import Foundation

protocol FeedLoader {
  func fetchData(completion: @escaping (Result<[FeedItem], Error>) -> Void)
}
