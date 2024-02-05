//
//  APIFetcherProtocol.swift
//  NYTimesPOC
//
//  Created by Jeevan Pandey on 25/08/23.
//


import Foundation
import Combine

// This is service class which calls API for news 
protocol ImageFetcherInterface {
  func fetchImage(url:URL, completion: @escaping (Result<Data, NetworkError>) -> ())
}
protocol NewsAPIFetcherInterface  {
  func getNewsArticleData() -> AnyPublisher<ArticleResponse, NetworkError>
}

class NewsService: NewsAPIFetcherInterface,ServerEndPoint {
  var headers: NetworkConfig.HTTPHeaderFields
  var baseURLString: String
  var requestMethod: NetworkConfig.HTTPMehod
  
  init(endpointConfig: ServerEndPoint) {
    self.baseURLString = endpointConfig.baseURLString
    self.requestMethod = endpointConfig.requestMethod
    self.headers = endpointConfig.headers
  }
  
  convenience init() {
    let defaltConfig = NewsAPIConfig.defaultConfig()
    self.init(endpointConfig: defaltConfig)
  }
    
  func getNewsArticleData() -> AnyPublisher<ArticleResponse, NetworkError> {
    DataRequestManager<ArticleResponse>().fetchData(url: baseURLString,
                                                    params: ["": ""],
                                                    httpHeader: headers,
                                                    requestType: requestMethod).eraseToAnyPublisher()
  }
}

class ImageService: ImageFetcherInterface {
  func fetchImage(url: URL, completion: @escaping (Result<Data, NetworkError>) -> ()) {
    DataRequestManager<Data>().loadData(url: url) { result in
      completion(result)
    }
  }
}


