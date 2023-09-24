//
//  DetailCoordinator.swift
//  NYTimesPOC
//
//  Created by Jeevan Pandey on 19/09/23.
//

import Foundation
import UIKit

class DetailCoordinator: Coordinator {
  var childCoordinators: [Coordinator] = [Coordinator]()
  
  var navigationController: UINavigationController
  weak var parentCoordinator: MainCoordinator?
  var detailVM: DetailViewModel
  
  init(navigationController:UINavigationController,detailVM: DetailViewModel) {
    self.navigationController = navigationController
    self.detailVM = detailVM
  }
  
  func start() {
    let detailVC = NewsDetailVC.instantiate()
    detailVC.detailVM = self.detailVM
    detailVC.coordinator = self
    self.navigationController.pushViewController(detailVC, animated: true)
  }
}
