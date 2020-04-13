import XCTest
@testable import RxSwiftBook4SampleCode

class RxSwiftCloneTests: XCTestCase {
    var expect: XCTestExpectation!
    var expectShared: XCTestExpectation!

    override func setUp() {
        expect = expectation(description: "")
        expect.expectedFulfillmentCount = 2
        expectShared = expectation(description: "Hot変換検証用")
        expectShared.expectedFulfillmentCount = 1
    }

    func test() {

        let observable = Observable.just(2)
            .map {
                self.expectShared.fulfill()
                return $0 * 10
            }
            .publish()

        XCTContext.runActivity(named: "connect前にsubscribeされた") { _ in
            let observerA = AnyObserver<Int> {
                switch $0 {
                case .next(let element):
                    XCTAssertEqual(element, 20)
                case .completed:
                    self.expect.fulfill()
                }
            }
            observable.subscribe(observerA)

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

        observable.connect()

        XCTContext.runActivity(named: "connect後にsubscribeされた") { _ in
            let observerC = AnyObserver<Int> { _ in
                XCTFail("このクロージャは呼び出されてはいけない")
            }
            observable.subscribe(observerC)
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }
}

