//
//  TranslateTestAppTests.swift
//  TranslateTestAppTests


import XCTest

@testable import TranslateTestApp

class TranslateTestAppTests: XCTestCase {
    
    private var translateService : TranslateService? = nil
    private var translateWordListViewModel : TranslateWordListViewModel? = nil
    

    override func setUpWithError() throws {
        translateService = TranslateService()
        translateWordListViewModel = TranslateWordListViewModel()
        
        
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
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
