import XCTest
@testable import MapDemo

class MapDemoTests: XCTestCase {

    var expect: XCTestExpectation!

    override func setUp() {
        expect = expectation(description: "")
        expect.expectedFulfillmentCount = 1
    }

    func test() {
        let observable = Observable.of(1, 2, 3)
            .map { $0 * 10 }  // 1. NEW: mapで10倍に変換

        var array: [Int] = []

        let observer = AnyObserver<Int> {
            switch $0 {
            case .next(let element):
                array.append(element)
            case .completed:
                // 2. NEW: 10倍されてるかを検証する
                XCTAssertEqual(array, [10, 20, 30])
                self.expect.fulfill()
            }
        }

        observable.subscribe(observer)

        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
