//
//  AnyError.swift
//  FeedUnitTesting
//
//  Created by Ahmed Fathy on 03/10/2024.
//

import Foundation

struct AnyError: Equatable {
  let id: UUID
  let error: Error

  init(id: UUID = UUID(), error: Error) {
    self.id = id
    self.error = error
  }

  static func == (lhs: AnyError, rhs: AnyError) -> Bool {
    lhs.id == rhs.id || lhs.error.localizedDescription == rhs.error.localizedDescription
  }
}
