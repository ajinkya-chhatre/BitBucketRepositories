//
//  BitBucketReposTests.swift
//  BitBucketReposTests
//
//  Created by achhatre on 27/06/21.
//

import XCTest
@testable import BitBucketRepos

class BitBucketReposTests: XCTestCase {

    var viewModel: ViewModel?
    
    override func setUpWithError() throws {
        self.viewModel = ViewModel()
    }

    func testParse() throws {
        let exp = expectation(description: "Loading Repositories")
        var repositories: [Repository]?
        
        // TODO: Mock this actual netwotk call using mocking framework like OHHTTPStubs
        self.viewModel?.loadRepositories(urlStr: Constants.bitBucketRepoURL) { (reposArray) in
            repositories = reposArray
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 5)
        
        guard let repos = repositories else {
            XCTAssert(false)
            return
        }

        XCTAssertEqual(repos.count, 10, "We should have loaded exactly 10 repositories.")
    }
    
    override func tearDownWithError() throws {
        self.viewModel = nil
    }

}
