//
//  DetailViewModel.swift
//  NYTimesPOC
//
//  Created by Jeevan Pandey on 25/08/23.
//

import Foundation
import UIKit
import Combine

class DetailViewModel {
  var title: String?
  var details: String?
  var imageURL: String?
  var publishedDate: String?
  var caption: String?
  var imageService: ImageFetcherInterface?
  private var cancellables = Set<AnyCancellable>()

  internal init(title: String? = nil,
                details: String? = nil,
                imageURL: String? = nil,
                publishedDate: String? = nil,
                caption: String? = nil,
                imageService: ImageFetcherInterface? = nil,
                cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
    self.title = title
    self.details = details
    self.imageURL = imageURL
    self.publishedDate = publishedDate
    self.caption = caption
    self.imageService = imageService
    self.cancellables = cancellables
  }
  
  func getImage(url: URL, completion: @escaping (Result<UIImage, NetworkError>) -> ()) {
    let responsePublisher  = imageService!.fetchImageForNewsItem(url: url)
    responsePublisher
      .sink { completion in
        switch completion {
          case .finished:
            debugPrint("Finsihed the request")
            break
          case .failure(let error):
            debugPrint("Some error \(error)")
          }
        }
      receiveValue: { image in
        print("response")
        completion(.success(image))
      }
  .store(in: &cancellables)
  }
}

