//
//  CellListVM.swift
//  NYTimesPOC
//
//  Created by Jeevan Pandey on 24/08/23.
//

import Foundation
import UIKit
struct CellListVM {
  var title: String
  var subtitle: String
  var imageString: String
  
  static func getImage(url: URL) async throws -> Data {
    let imageService =  ImageService()
    let imageData = try await imageService.fetchImage(url: url)
     return imageData
  }
}
