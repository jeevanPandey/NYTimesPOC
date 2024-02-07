//
//  DataRequestManager.swift
//  NYTimesPOC
//
//  Created by Jeevan Pandey on 25/08/23.
//



import UIKit
import Combine

class DataRequestManager <T: Codable> {
  private let cache: NSCache<NSURL, UIImage>
  init(cache: NSCache<NSURL, UIImage> = .init()) {
          self.cache = cache
  }
  
  func fetchData(url: String,
                 params: [String: String],
                 httpHeader: NetworkConfig.HTTPHeaderFields,
                 requestType:NetworkConfig.HTTPMehod) -> AnyPublisher<T, NetworkError> {
    guard let url = URL(string: url) else {
      return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
    }
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
  
  func loadImageData(url: URL) -> AnyPublisher<UIImage, NetworkError> {
    if let image = cache.object(forKey: url as NSURL) {
      return Just(image)
        .setFailureType(to: NetworkError.self)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    return URLSession.shared.dataTaskPublisher(for: url)
      .tryMap { (data, response) -> Data in
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
          throw NetworkError.invalidData
        }
        return data
      }
      .tryMap { data in
        guard let image = UIImage(data: data) else {
          throw URLError(.badServerResponse, userInfo: [
            NSURLErrorFailingURLErrorKey: url
          ])
        }
        return image
      }
      .mapError({ error in
        NetworkError.decodingError(err: "decoding error")
      })
      .receive(on: DispatchQueue.main)
      .handleEvents(receiveOutput: { [cache] image in
        cache.setObject(image, forKey: url as NSURL)
      })
      .eraseToAnyPublisher()
  }
}

