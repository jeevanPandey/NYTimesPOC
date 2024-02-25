//
//  DataRequestManager.swift
//  NYTimesPOC
//
//  Created by Jeevan Pandey on 25/08/23.
//



import Foundation

class DataRequestManager <T: Codable> {
    
  func makeAPICall(url: String, params: [String: String], httpHeader: NetworkConfig.HTTPHeaderFields, requestType:NetworkConfig.HTTPMehod ) async throws -> T {
    guard let secondaryURL = URL(string: url) else {
        print("Error: cannot create URL")
      throw NetworkError.invalidResponse
    }
    var request = URLRequest(url: secondaryURL)
    request.httpMethod = requestType.rawValue
    httpHeader.setHeader(urlRequest: &request)
    
    let config = URLSessionConfiguration.ephemeral
    let session = URLSession(configuration: config)
    let (data,response) = try await session.data(for: request)
      guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
          print("Error: HTTP request failed")
        throw NetworkError.invalidResponse
      }
      let json = try JSONDecoder().decode(T.self, from: data)
      return json
  }

  func loadData(url: URL) async throws -> Data {
 /*   let tempDir = FileManager.default.temporaryDirectory
    let fileCachePath = tempDir.appendingPathComponent(url.lastPathComponent,
                                                      isDirectory: false)
    do {
      let data = try Data(contentsOf: fileCachePath)
      return data
    } catch let error {
      debugPrint("\(error)")
      throw NetworkError.invalidResponse
      
    } */
    let (data,response) = try await URLSession.shared.data(from: url)
    guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
        print("Error: HTTP request failed")
      throw NetworkError.invalidResponse
    }
    return data
  }
}

