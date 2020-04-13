//import XCTest
//@testable import ObservableDemo
//
//class ObservableDemo4Tests: XCTestCase {
//    var expect: XCTestExpectation!
//
//    override func setUp() {
//        expect = expectation(description: "")
//        // 1. NEW: fulfillがonNextとonCompletedで2回実行されるかを検証
//        expect.expectedFulfillmentCount = 2
//    }
//
//    func test() {
//        let element = String(Int.random(in: Int.min..<Int.max))
//
//        let observable = Observable.just(element)
//        observable.subscribe(onNext: { [weak self] in
//            XCTAssertEqual($0, element)
//            self?.expect.fulfill()
//        }, onCompleted: { [weak self] in
//            // 2. NEW: completedクロージャが実行されることを条件にする
//            self?.expect.fulfill()
//        })
//
//        waitForExpectations(timeout: 0.1, handler: nil)
//    }
//}
