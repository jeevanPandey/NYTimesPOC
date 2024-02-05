//
//  DataRequestManager.swift
//  NYTimesPOC
//
//  Created by Jeevan Pandey on 25/08/23.
//



import Foundation
import Combine

class DataRequestManager <T: Codable> {
  
  func fetchData1(url: String,
                 params: [String: String],
                 httpHeader: NetworkConfig.HTTPHeaderFields,
                 requestType:NetworkConfig.HTTPMehod) -> AnyPublisher<T, Error> {
    guard let secondaryURL = URL(string: url) else {
      print("Error: cannot create URL")
       return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
    }
    
    var request = URLRequest(url: secondaryURL)
    request.httpMethod = requestType.rawValue
    httpHeader.setHeader(urlRequest: &request)
    
    let config = URLSessionConfiguration.ephemeral
    let session = URLSession(configuration: config)
    return session.dataTaskPublisher(for: request).tryMap { (data, response) -> Data in
      guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
        throw NetworkError.invalidData
      }
      return data
    }
    .tryMap({ myData in
      do {
          return try JSONDecoder().decode(T.self, from: myData)
        
      } catch {
        throw NetworkError.decodingError(err: "decoding error")
      }
    })
    .mapError({ error in
      NetworkError.decodingError(err: "decoding error")
    })
    .receive(on: DispatchQueue.main)
    .eraseToAnyPublisher()
  }
  
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

    func makeAPICall(url: String, params: [String: String], httpHeader: NetworkConfig.HTTPHeaderFields, requestType:NetworkConfig.HTTPMehod, complete: @escaping (Result<T, NetworkError>) -> ()) {
        guard let secondaryURL = URL(string: url) else {
            print("Error: cannot create URL")
            return
        }
        var request = URLRequest(url: secondaryURL)
        request.httpMethod = requestType.rawValue
        httpHeader.setHeader(urlRequest: &request)
        
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config)
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                if let error = error?.localizedDescription {
                    complete(.failure(.error(err: error)))
                }
                return
            }
            guard let data = data else {
                print("Error: did not receive data")
                complete(.failure(.invalidData))
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                complete(.failure(.invalidResponse))
                return
            }
            
            do {
                let json = try JSONDecoder().decode(T.self, from: data)
                complete(.success(json))
            } catch let err {
                print(String(describing: err))
                complete(.failure(.decodingError(err: err.localizedDescription)))
            }
        }.resume()
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

