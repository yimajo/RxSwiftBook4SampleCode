import XCTest
@testable import ObserverDemo

class ObserverDemo1Tests: XCTestCase {
    var expect: XCTestExpectation!

    override func setUp() {
        expect = expectation(description: "")
        // 1. UPDATE: fulfillがonNextとonCompletedで2回づつ実行されるかを検証
        expect.expectedFulfillmentCount = 2 * 2
    }

    func test() {
        // 2. UPDATE: 再び定数2に戻す
        let observable = Observable.just(2)
        // 3. NEW: Observerに監視させるようにする
        let observer = AnyObserver { [weak self] (event: Event<Int>) in
            switch event {
            case .next(let element):
                XCTAssertEqual(element, 2)
                self?.expect.fulfill()
            case .completed:
                self?.expect.fulfill()
            }
        }
        // 4. NEW: 監視対象のObservableをObserverでsubscribe
        observable.subscribe(observer)

        observable.subscribe(onNext: { element in
            XCTAssertEqual(element, 2)
            self.expect.fulfill()
        }, onCompleted: {
            self.expect.fulfill()
        })

        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
