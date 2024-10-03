//
//  FeedViewControllerHelpers.swift
//  FeedUnitTesting
//
//  Created by Ahmed Fathy on 30/09/2024.
//

@testable import FeedUnitTesting
import Foundation
import UIKit

extension FeedViewController {
  
  var feedItemsCount: Int {
    feedItems.count
  }

  func numberOfRows(in section: Int = 0) -> Int {
    tableView.numberOfRows(inSection: section)
  }

  func cell(for index: Int) -> FeedCell? {
    tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? FeedCell
  }
  
  func didSelectCell(_ index: Int) {
    tableView.delegate?.tableView?(tableView, didSelectRowAt: IndexPath(row: index, section: 0))
  }
}
