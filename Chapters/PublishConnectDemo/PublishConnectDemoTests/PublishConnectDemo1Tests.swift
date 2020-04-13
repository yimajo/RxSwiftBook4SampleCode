import XCTest
@testable import PublishConnectDemo

class PublishConnectDemoTests: XCTestCase {
    var expect: XCTestExpectation!
    // 1. NEW: Hot変換を検証する用途
    var expectShared: XCTestExpectation!

    override func setUp() {
        expect = expectation(description: "")
        expect.expectedFulfillmentCount = 2
        // 2. NEW: .mapが1回しか動かないことを検証
        expectShared = expectation(description: "Hot変換検証用")
        expectShared.expectedFulfillmentCount = 1
    }

    func test() {
        // 3. UPDATE: 整数の2を10倍にするmap処理を行い、publish
        let observable = Observable.just(2)
            .map {
                self.expectShared.fulfill()
                return $0 * 10
            }
            .publish()

        XCTContext.runActivity(named: "connect前にsubscribeされた") { _ in
            // 4. UPDATE: connect前にObserverAでsubscribeし10倍になっているか検証
            let observerA = AnyObserver<Int> {
                switch $0 {
                case .next(let element):
                    XCTAssertEqual(element, 20)
                case .completed:
                    self.expect.fulfill()
                }
            }
            observable.subscribe(observerA)

            // 5. UPDATE: connect前にObserverBでもsubscribeし10倍になっているか検証
            let observerB = AnyObserver<Int> {
                switch $0 {
                case .next(let element):
                    XCTAssertEqual(element, 20)
                case .completed:
                    self.expect.fulfill()
                }
            }
            observable.subscribe(observerB)
        }

        // 6. NEW: connectでイベントを放流する
        observable.connect()

        // 7. NEW: connect後にObserverCでsubscribeさせる
        XCTContext.runActivity(named: "connect後にsubscribeされた") { _ in
            let observerC = AnyObserver<Int> { _ in
                XCTFail("このクロージャは呼び出されてはいけない")
            }
            observable.subscribe(observerC)
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }
}

