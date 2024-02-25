//
//  DataRequestManager.swift
//  NYTimesPOC
//
//  Created by Jeevan Pandey on 25/08/23.
//



import Foundation

class DataRequestManager <T: Codable> {
    
  func makeAPICall(url: String, params: [String: String],
                   httpHeader: NetworkConfig.HTTPHeaderFields,
                   requestType:NetworkConfig.HTTPMehod) async throws -> T {
    guard let secondaryURL = URL(string: url) else {
        print("Error: cannot create URL")
      throw NetworkError.invalidResponse
    }
    var request = URLRequest(url: secondaryURL)
    request.httpMethod = requestType.rawValue
    httpHeader.setHeader(urlRequest: &request)
    let responseData =  try await makeServerCall(urlRequest: request)
    return responseData
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
    let request = URLRequest(url: url)
    let responseData =  try await makeServerCall(urlRequest: request)
    if let responseData = responseData as? Data {
      return responseData
    } else {
      throw NetworkError.invalidResponse
    }
  }
  
  private func makeServerCall(urlRequest: URLRequest) async throws -> T {
    let config = URLSessionConfiguration.ephemeral
    let session = URLSession(configuration: config)
    let (data,response) = try await session.data(for: urlRequest)
      guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
          print("Error: HTTP request failed")
        throw NetworkError.invalidResponse
      }
    if let data = data as? T, T.self == Data.self {
      return data
    }
    let json = try JSONDecoder().decode(T.self, from: data)
    return json
  }
}

