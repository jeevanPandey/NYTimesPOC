//
//  AppUtil.swift
//  NYTimesPOC
//
//  Created by Jeevan Pandey on 25/08/23.
//
// 2023-08-24T04:35:57-04:00
import Foundation
extension String {
  func getDate() -> String {
    let giveDF = DateFormatter()
    giveDF.dateFormat = "yyyy-MM-dd'T'HH:mm:ss-HH:mm"
    let oldDate = giveDF.date(from: self)
    let updatedDF = DateFormatter()
    updatedDF.dateFormat = "MMM dd yyyy h:mm a"
    guard let oldDate = oldDate else {
      return ""
    }
    return updatedDF.string(from: oldDate)
  }
}

