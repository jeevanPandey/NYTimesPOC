//
//  ServerEndPoint.swift
//  NYTimesPOC
//
//  Created by Jeevan Pandey on 25/08/23.
//


import Foundation

protocol ServerEndPoint {
    var baseURLString: String { get }
    var requestMethod: NetworkConfig.HTTPMehod { get }
    var headers: NetworkConfig.HTTPHeaderFields { get }
}

struct NewsAPIConfig: ServerEndPoint {
  var baseURLString: String
  var requestMethod: NetworkConfig.HTTPMehod
  var headers: NetworkConfig.HTTPHeaderFields
  
  static func defaultConfig() -> NewsAPIConfig {
   return  NewsAPIConfig(baseURLString: NetworkConfig.getURLForNewList(),
                  requestMethod: .GET, headers: .appJson)
  }

}
