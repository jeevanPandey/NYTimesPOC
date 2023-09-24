//
//  Coordinator.swift
//  NYTimesPOC
//
//  Created by Jeevan Pandey on 19/09/23.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
  var childCoordinators: [Coordinator] { get set }
  var navigationController: UINavigationController { get set}
  
  func start()
}

extension Coordinator {
    func removeChildCoordinator(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
    }
}
