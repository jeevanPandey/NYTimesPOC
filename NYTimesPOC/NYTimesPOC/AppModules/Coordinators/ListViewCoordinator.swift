//
//  ListViewCoordinator.swift
//  NYTimesPOC
//
//  Created by Jeevan Pandey on 20/09/23.
//

import Foundation
import UIKit

class ListViewCoordinator: NSObject,Coordinator {
  var childCoordinators =  [Coordinator]()
  
  var navigationController: UINavigationController
  init(navigationController:UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let listVC = NewsListVC.instantiate()
    listVC.coordinator = self
    self.navigationController.pushViewController(listVC, animated: false)
  }
  
  func navigateToDetailVC(withViewModel: DetailViewModel) {
    let child = DetailCoordinator(navigationController: self.navigationController,
                                  detailVM: withViewModel)
    childCoordinators.append(child)
    child.start()
  }
}



