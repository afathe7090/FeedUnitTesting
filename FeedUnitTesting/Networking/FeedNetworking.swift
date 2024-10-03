//
//  FeedNetworking.swift
//  FeedUnitTesting
//
//  Created by Ahmed Fathy on 14/09/2024.
//

import Foundation

import Foundation

class NetworkManager {
  static let shared = NetworkManager()
    
  private init() {}
  func fetchData<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {

    let task = URLSession.shared.dataTask(with: url) { data, _, error in
            
      if let error = error {
        DispatchQueue.main.async {
          completion(.failure(error))
        }
        return
      }
            
      guard let data = data else {
        print("No data received")
        return
      }
            
      do {
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        DispatchQueue.main.async {
          completion(.success(decodedData))
        }
      } catch {
        DispatchQueue.main.async {
          completion(.failure(error))
        }
      }
    }
        
    task.resume()
  }
}
