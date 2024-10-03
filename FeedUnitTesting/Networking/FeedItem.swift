//
//  FeedItem.swift
//  FeedUnitTesting
//
//  Created by Ahmed Fathy on 14/09/2024.
//

import Foundation

struct FeedItem: Decodable, Equatable {
  let id: Int
  let name: String
  let email: String?
}
