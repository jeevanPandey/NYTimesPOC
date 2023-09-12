//
//  APIFetcherProtocol.swift
//  NYTimesPOC
//
//  Created by Jeevan Pandey on 25/08/23.
//


import Foundation

protocol ImageFetcherInterface {
  func fetchImage(url:URL, completion: @escaping (Result<Data, NetworkError>) -> ())
}
protocol NewsAPIFetcherInterface  {
  func fetchNewArticleData(completion: @escaping (Result<ArticleResponse, NetworkError>) -> ())
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
  
  func fetchNewArticleData(completion: @escaping(Result<ArticleResponse, NetworkError>) -> ()) {
    DataRequestManager<ArticleResponse>().makeAPICall(url: self.baseURLString, params: ["": ""],
                                                      httpHeader: self.headers , requestType: self.requestMethod) { result in
      completion(result)
    }
  }
}

class ImageService: ImageFetcherInterface {
  func fetchImage(url: URL, completion: @escaping (Result<Data, NetworkError>) -> ()) {
    DataRequestManager<Data>().loadData(url: url) { result in
      completion(result)
    }
  }
}


