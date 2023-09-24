//
//  NewsDetailVC.swift
//  NYTimesPOC
//
//  Created by Jeevan Pandey on 25/08/23.
//

import UIKit

class NewsDetailVC: UIViewController {

  @IBOutlet weak var articleImage: UIImageView!
  @IBOutlet weak var articleCaption: UILabel!
  
  @IBOutlet weak var articleTitle: UILabel!
  @IBOutlet weak var articleDetails: UILabel!
  @IBOutlet weak var articlePublisheDate: UILabel!
  var detailVM: DetailViewModel!
  var coordinator: Coordinator?

  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    setupUI()
  }
  
  func setupUI() {
    articleCaption.text = detailVM.caption
    articleTitle.text = detailVM.title
    articleDetails.text = detailVM.details
    articlePublisheDate.text = detailVM.publishedDate
    guard let imageURLStr = detailVM.imageURL, let imageURL = URL(string: imageURLStr) else { return }
    detailVM.getImage(url: imageURL) { result in
      DispatchQueue.main.async {
        switch result {
          case .success(let imageData):
            self.articleImage.image = imageData
          case .failure(let error):
            print("response is \(error)")
        }
      }
    }
  }
}
