//
//  NewsCell.swift
//  NYTimesPOC
//
//  Created by Jeevan Pandey on 23/08/23.
//

import UIKit

class NewsCell: UITableViewCell {
  static var identifier: String { return String(describing: self) }
  static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }

  @IBOutlet weak var articleImage: UIImageView!
  @IBOutlet weak var articleTitle: UILabel!
  @IBOutlet weak var articleSubtitle: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    articleImage.layer.borderWidth = 1.0
    articleImage.layer.masksToBounds = false
    articleImage.layer.borderColor = UIColor.white.cgColor
    articleImage.clipsToBounds = true
  }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func configureCell(cellViewModel: CellListVM) {
    articleTitle.text = cellViewModel.title
    articleSubtitle.text = cellViewModel.subtitle
    if let url = URL(string: cellViewModel.imageString), !cellViewModel.imageString.isEmpty {
      Task {
        do {
          let imageData = try await CellListVM.getImage(url: url)
          self.articleImage.image = UIImage(data: imageData)
        } catch {
          print("response is \(error)")
        }
      }
    }
  }
}
