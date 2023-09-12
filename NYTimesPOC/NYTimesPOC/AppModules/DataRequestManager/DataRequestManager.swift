//
//  DataRequestManager.swift
//  NYTimesPOC
//
//  Created by Jeevan Pandey on 25/08/23.
//



import Foundation

class DataRequestManager <T: Codable> {
    
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

