import XCTest
@testable import OfDemo

class OfDemo1Tests: XCTestCase {
    var expect: XCTestExpectation!

    override func setUp() {
        expect = expectation(description: "")
        // 1. NEW: fulfillを1つのObserverのonComleteのみで実行されているか検証
        expect.expectedFulfillmentCount = 1
    }

    func test() {
        // 2. NEW: ofメソッドによりストリームを作成する
        let observable = Observable.of(1, 2, 3)
        // 3. NEW: .nextごとの結果を保持して.completedで検証できるようにする
        var output: [Int] = []

        let observer = AnyObserver { (event: Event<Int>) in
            switch event {
            case .next(let element):
                // 4. NEW: 都度入力値をoutputにつめていく
                output.append(element)
            case .completed:
                // 5. NEW: 最終的に入力値と結果を比較する
                XCTAssertEqual(output, [1, 2, 3])
                self.expect.fulfill()
            }
        }

        observable.subscribe(observer)

        waitForExpectations(timeout: 0.1, handler: nil)
    }
}

