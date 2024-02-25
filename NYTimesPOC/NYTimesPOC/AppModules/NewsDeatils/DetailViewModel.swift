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
  
  func getImage(url: URL) async throws -> Data {
    let imageService =  ImageService()
    let imageData = try await imageService.fetchImage(url: url)
     return imageData
  }

}

