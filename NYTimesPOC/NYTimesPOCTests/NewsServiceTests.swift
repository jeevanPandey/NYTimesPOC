//
//  NewsServiceTests.swift
//  NYTimesPOCTests
//
//  Created by Jeevan Pandey on 08/09/23.
//

import XCTest
@testable import NYTimesPOC

class NewsServiceTests: XCTestCase {
  var sut: MockNewService!
  
  override func setUp() {
    super.setUp()
    sut = MockNewService()
  }

  func testMovieFetchAPI() {
    let expectation = self.expectation(description: "News fetch API")
      sut.fetchNewArticleData { result in
        switch result {
          case .success(let response):
            if let articles = response.articles, let firstObj = articles.first {
              XCTAssertEqual(firstObj.section, "world")
              XCTAssertEqual(firstObj.title, "‘Aren’t You a Man?’: How Russia Goads Citizens Into the Army")
            }
          case .failure( _):
            debugPrint("Error")
        }
        expectation.fulfill()
    }
    wait(for: [expectation], timeout: 5.0)
  }
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testExample() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
  
  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
