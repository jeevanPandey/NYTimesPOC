//
//  APIFetcherProtocol.swift
//  NYTimesPOC
//
//  Created by Jeevan Pandey on 25/08/23.
//


import UIKit
import Combine

// This is service class which calls API for news 
protocol ImageFetcherInterface {
  func fetchImageForNewsItem(url:URL) -> AnyPublisher<UIImage, NetworkError>
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
  func fetchImageForNewsItem(url: URL) -> AnyPublisher<UIImage, NetworkError> {
    DataRequestManager<Data>().loadImageData(url: url).eraseToAnyPublisher()
  }
}


