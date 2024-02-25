//
//  CellListVM.swift
//  NYTimesPOC
//
//  Created by Jeevan Pandey on 24/08/23.
//

import Foundation
import UIKit
import Combine
class CellListVM {
  internal init(title: String? = nil,
                subtitle: String? = nil,
                imageString: String? = nil) {
    self.title = title
    self.subtitle = subtitle
    self.imageString = imageString
  }
  
  var title: String?
  var subtitle: String?
  var imageString: String?
  static var cancellables = Set<AnyCancellable>()

  static func getImage(url: URL, completion: @escaping (Result<UIImage, NetworkError>) -> ()) {
    var imageService =  ImageService()
    let responsePublisher  = imageService.fetchImageForNewsItem(url: url)
    responsePublisher
      .sink { completion in
        switch completion {
          case .finished:
            debugPrint("Finsihed the request")
            break
          case .failure(let error):
            debugPrint("Some error")
        }
      }
  receiveValue: { image in
    print("response")
    completion(.success(image))
  }
  .store(in: &cancellables)
  }
}
