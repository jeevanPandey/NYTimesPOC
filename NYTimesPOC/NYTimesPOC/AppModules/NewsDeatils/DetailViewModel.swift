//
//  DetailViewModel.swift
//  NYTimesPOC
//
//  Created by Jeevan Pandey on 25/08/23.
//

import Foundation
import UIKit
struct DetailViewModel {
  var title: String
  var details: String
  var imageURL: String?
  var publishedDate: String
  var caption: String
  var imageService: ImageFetcherInterface
  
  func getImage(url: URL, completion: @escaping (Result<UIImage, NetworkError>) -> ()) {
    DispatchQueue.global().async {
      imageService.fetchImage(url: url) {  (result) in
        switch result {
          case .success(let imageData):
              guard let image = UIImage(data: imageData) else {
                completion(.failure(.decodingError(err: "Error while Downloading")))
                return
              }
              completion(.success(image))
          case .failure(let error):
            print("response is \(error)")
            completion(.failure(.decodingError(err: "Error while Downloading")))
        }
      }
    }
  }

}

