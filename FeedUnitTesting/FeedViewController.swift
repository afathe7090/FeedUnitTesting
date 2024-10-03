//
//  ViewController.swift
//  FeedUnitTesting
//
//  Created by Ahmed Fathy on 14/09/2024.
//

import UIKit

class FeedViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!

  private(set) var feedItems: [FeedItem] = []
  private let loader: FeedLoader
  private let presenter: FeedViewRouter
  
  required init?(
    coder: NSCoder,
    loader: FeedLoader,
    presenter: FeedViewRouter
  ) {
    self.loader = loader
    self.presenter = presenter
    super.init(coder: coder)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
      
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTableView()
    loadAPI()
  }

  func configureTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
  }

  func loadAPI() {
    presenter.showLoader()
    loader.fetchData { result in
      switch result {
      case .success(let items):
        self.feedItems = items
        
        if items.isEmpty {
          self.presenter.showEmptyState()
        }
        self.tableView.reloadData()
      case .failure(let failure):
        self.presenter.showError(failure)
      }
      self.presenter.hideLoader()
    }
  }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return feedItems.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
    cell.titleLbl.text = feedItems[indexPath.row].name
    cell.bodyLbl.text = feedItems[indexPath.row].email
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    presenter.show(UIViewController())
  }
}
