//
//  NewsListViewModel.swift
//  NYTimesPOC
//
//  Created by Jeevan Pandey on 23/08/23.
//

import Foundation
import UIKit
import Combine
class NewsListViewModel {
  
  private var newsListService: NewsAPIFetcherInterface
  private var newList = [Article]()
  var reloadTableView: (() -> Void)?
  private var cancellables = Set<AnyCancellable>()
  var cellListVM =  [CellListVM]() {
    didSet {
      reloadTableView?()
    }
  }
  
  init(service: NewsAPIFetcherInterface = NewsService()) {
    self.newsListService = service
  }
  
  class func defaultConfig() -> NewsAPIConfig {
    NewsAPIConfig(baseURLString: NetworkConfig.getURLForNewList(),
                  requestMethod: .GET, headers: .appJson)
  }
  
  func getLatestNews() {
    let responsePublisher  = newsListService.getNewsArticleData()
    responsePublisher
      .sink { completion in
        switch completion {
          case .finished:
            debugPrint("Finsihed the request")
            break
          case .failure(let error):
            self.showError(error: error)
        }
      }
  receiveValue: { [weak self] response in
    print("response")
    self?.refreshUI(response: response)
  }
  .store(in: &cancellables)
    
  }
  
  private func refreshUI(response: ArticleResponse) {
    if let articles = response.articles {
      newList.removeAll()
      newList.append(contentsOf: articles)
      createCellViewModel()
    }
  }
  
  private func showError(error: Error) {
    switch error {
    case let decodingError as DecodingError:
        debugPrint("Decoding error")
    case let apiError as NetworkError:
        debugPrint("NetworkError")
    default:
        debugPrint("Unknown error")
    }
  }
  
  private func createCellViewModel() {
    let modifiedArray = filterArray(articles: self.newList)
    let cellVM =  modifiedArray.map { eachArtitle -> CellListVM in
      return CellListVM(title: eachArtitle.title ?? "", subtitle: eachArtitle.abstract ?? "",
                        imageString: getMediaURLPath(article: eachArtitle),
                        imageService: ImageService())
    }
    cellListVM = cellVM
  }
  
  private func filterArray(articles: [Article]) -> [Article] {
    let filterArray = articles.filter { eachItem in
      if let title = eachItem.title {
        return !title.isEmpty
      }
      return false
    }
    return filterArray
  }
  
  private func getMediaURLPath(article: Article) -> String {
    var mediaPath = ""
    if let allMedia = article.multimedia,
       let firstObj = allMedia.first,
       let path = firstObj.url {
      mediaPath = path
    }
    return mediaPath
  }
  
  func getDetailViewModel(rowIndex: Int) -> DetailViewModel {
    let modifiedArray = filterArray(articles: self.newList)
    let eachArtitle = modifiedArray[rowIndex]
    let section = eachArtitle.section ?? ""
    let subsection = eachArtitle.subsection ?? ""
    let detailVMs =  DetailViewModel(title: eachArtitle.title ?? "",
                                     details: eachArtitle.abstract ?? "",
                                     imageURL: getMediaURLPath(article: eachArtitle),
                                     publishedDate: eachArtitle.published_date?.getDate() ?? "",
                                     caption:section + "|" + subsection,
                                     imageService: ImageService())
    return detailVMs
  }
  
}
