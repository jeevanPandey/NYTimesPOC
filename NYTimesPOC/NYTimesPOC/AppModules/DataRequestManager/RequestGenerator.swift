//
//  APIFetcherProtocol.swift
//  NYTimesPOC
//
//  Created by Jeevan Pandey on 25/08/23.
//


import Foundation

// This is service class which calls API for news 
protocol ImageFetcherInterface {
  func fetchImage(url: URL) async throws -> Data
}
protocol NewsAPIFetcherInterface  {
  func fetchNewArticleData() async throws -> ArticleResponse

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
  
  func fetchNewArticleData() async throws -> ArticleResponse {
    return try await DataRequestManager<ArticleResponse>().makeAPICall(url: self.baseURLString,
                                                                               params: ["": ""],
                                                                               httpHeader: self.headers,
                                                                               requestType: self.requestMethod)
  }
}

class ImageService: ImageFetcherInterface {
  func fetchImage(url: URL) async throws -> Data {
   return try await DataRequestManager<Data>().loadData(url: url)
  }
}


