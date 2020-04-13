//import XCTest
//@testable import ObservableDemo
//
//class ObservableDemo3Tests: XCTestCase {
//    var expect: XCTestExpectation!
//
//    override func setUp() {
//        expect = expectation(description: "")
//    }
//
//    func test() {
//        // 1. UPDATE: ランダムな整数を文字列とする
//        let element = String(Int.random(in: Int.min..<Int.max))
//
//        let observable = Observable.just(element)
//        observable.subscribe(onNext: { [weak self] in
//            XCTAssertEqual($0, element)
//            self?.expect.fulfill()
//        })
//
//        waitForExpectations(timeout: 0.1, handler: nil)
//    }
//}
