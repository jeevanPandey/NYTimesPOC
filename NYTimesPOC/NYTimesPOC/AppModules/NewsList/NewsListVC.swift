//
//  NewsListVC.swift
//  NYTimesPOC
//
//  Created by Jeevan Pandey on 23/08/23.
//

import UIKit

class NewsListVC: UIViewController {

  @IBOutlet weak var tableview: UITableView!
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  let viewModel = NewsListViewModel()
  weak var coordinator: ListViewCoordinator?
  override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "News List"
        setupUI()
        setupViewModel()
  }
  
  func setupUI() {
    tableview.delegate = self
    tableview.dataSource = self
    tableview.estimatedRowHeight = 200.0
    tableview.register(NewsCell.nib, forCellReuseIdentifier: NewsCell.identifier)
    activityIndicator.startAnimating()
  }
  
  func setupViewModel() {
    viewModel.getLatestNews()
    viewModel.reloadTableView = { [weak self] in
        DispatchQueue.main.async {
            self?.tableview.reloadData()
            self?.activityIndicator.isHidden = true
        }
    }
  }
}

extension NewsListVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell else { fatalError("xib does not exists") }
    cell.configureCell(cellViewModel: viewModel.cellListVM[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.cellListVM.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}

extension NewsListVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {     
    coordinator?.navigateToDetailVC(withViewModel: viewModel.getDetailViewModel(rowIndex: indexPath.row))
  }
}
