//
//  DataRequestManager.swift
//  NYTimesPOC
//
//  Created by Jeevan Pandey on 25/08/23.
//



import Foundation
import Combine

class DataRequestManager <T: Codable> {
  
  func fetchData(url: String,
                 params: [String: String],
                 httpHeader: NetworkConfig.HTTPHeaderFields,
                 requestType:NetworkConfig.HTTPMehod) -> AnyPublisher<T, NetworkError> {
    guard let url = URL(string: url) else {
      return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
    }
    print("URL is \(url.absoluteString)")
    var request = URLRequest(url: url)
    request.httpMethod = requestType.rawValue
    httpHeader.setHeader(urlRequest: &request)
    
    let config = URLSessionConfiguration.ephemeral
    let session = URLSession(configuration: config)
    
    return session.dataTaskPublisher(for: request)
      .tryMap { (data, response) -> Data in
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
          throw NetworkError.invalidData
        }
        return data
      }
      .decode(type: T.self, decoder: JSONDecoder())
      .mapError({ error in
        NetworkError.decodingError(err: "decoding error")
      })
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }
  
  func loadData(url: URL, complete: @escaping (Result<Data, NetworkError>) -> ()) {
    let tempDir = FileManager.default.temporaryDirectory
    let fileCachePath = tempDir.appendingPathComponent(url.lastPathComponent,
                                                      isDirectory: false)
    do {
      let data = try Data(contentsOf: fileCachePath)
      complete(.success(data))
      return
    } catch let error {
      debugPrint("\(error)")
      complete(.failure(.decodingError(err: "Error while Catching")))
      
    }
    download(url: url, toFile: fileCachePath) { (error) in
      do {
        let data = try Data(contentsOf: fileCachePath)
        complete(.success(data))
        return
      } catch let error {
        debugPrint("\(error)")
        complete(.failure(.decodingError(err: "Error while Downloading")))
      }
    }
  }

 private func download(url: URL, toFile file: URL, completion: @escaping (Error?) -> Void) {
      let task = URLSession.shared.downloadTask(with: url) {
          (tempURL, response, error) in
          guard let tempURL = tempURL else {
              completion(error)
              return
          }
          do {
              if !FileManager.default.fileExists(atPath: file.path) {
                 // try FileManager.default.removeItem(at: file)
                try FileManager.default.copyItem(at: tempURL,to: file)
              }
              completion(nil)
          }
          catch let fileError {
              completion(fileError)
          }
      }
      task.resume()
  }
}

