//import XCTest
//@testable import ObservableDemo
//
//class ObservableDemo2Tests: XCTestCase {
//    var expect: XCTestExpectation!
//
//    override func setUp() {
//        expect = expectation(description: "")
//    }
//
//    func test() {
//        // NEW: Intの範囲でランダムな整数を作る
//        let element = Int.random(in: Int.min..<Int.max)
//
//        let observable = Observable.just(element)
//        observable.subscribe(onNext: { [weak self] in
//            // 作成した値が流れるか検証する
//            XCTAssertEqual($0, element)
//            self?.expect.fulfill()
//        })
//
//        waitForExpectations(timeout: 0.1, handler: nil)
//    }
//}
