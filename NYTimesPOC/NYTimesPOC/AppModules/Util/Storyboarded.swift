//
//  Storyboarded.swift
//  NYTimesPOC
//
//  Created by Jeevan Pandey on 19/09/23.
//

import Foundation
import UIKit


extension UIViewController {
  static func instantiate() -> Self {
      let fullName = NSStringFromClass(self)
      let className = fullName.components(separatedBy: ".")[1]
      let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
      return storyboard.instantiateViewController(withIdentifier: className) as! Self
  }
}

/*
protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        // this pulls out "MyApp.MyViewController"
        let fullName = NSStringFromClass(self)

        // this splits by the dot and uses everything after, giving "MyViewController"
        let className = fullName.components(separatedBy: ".")[1]

        // load our storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // instantiate a view controller with that identifier, and force cast as the type that was requested
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}

*/
