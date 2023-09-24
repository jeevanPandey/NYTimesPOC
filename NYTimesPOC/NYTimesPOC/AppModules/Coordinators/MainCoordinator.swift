//
//  MainCoordinator.swift
//  NYTimesPOC
//
//  Created by Jeevan Pandey on 19/09/23.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
  var childCoordinators: [Coordinator] = [Coordinator]()
  
  var navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let childCoordinator = ListViewCoordinator(navigationController: self.navigationController)
    childCoordinators.append(childCoordinator)
    childCoordinator.start()
  }
  
}
