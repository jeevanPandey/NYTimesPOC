//
//  MockNewService.swift
//  NYTimesPOCTests
//
//  Created by Jeevan Pandey on 08/09/23.
//

import Foundation
@testable import NYTimesPOC

class MockNewService: NewsAPIFetcherInterface {
  func fetchNewArticleData(completion: @escaping (Result<ArticleResponse, NetworkError>) -> ()) {
    let jsonData = loadLocalJSONData()
    do {
        let json = try JSONDecoder().decode(ArticleResponse.self, from: jsonData)
      completion(.success(json))
    } catch let err {
        print(String(describing: err))
      completion(.failure(.decodingError(err: err.localizedDescription)))
    }
  }
  
  private func loadLocalJSONData() -> Data {
      let testBundle = Bundle(for:  type(of: self))
      guard let url = testBundle.url(forResource: "MockSample", withExtension: "json"), let data = try? Data(contentsOf: url) else {
          fatalError("Failed to load local JSON data")
      }
      return data
  }
  
}


