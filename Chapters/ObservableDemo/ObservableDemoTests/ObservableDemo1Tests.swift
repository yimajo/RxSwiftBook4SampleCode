import XCTest
@testable import ObservableDemo

class ObservableDemoTests: XCTestCase {
    var expect: XCTestExpectation!

    override func setUp() {
        // メソッドが実行されなければエラーになるようなインスタンスを用意
        expect = expectation(description: "")
    }

    func test() {
        let observable = Observable.just(2)
        observable.subscribe(onNext: { [weak self] in
            // 2が検出できるかを検証
            XCTAssertEqual($0, 2)
            // fulfillが実行されなければテスト失敗となるように
            self?.expect.fulfill()
        })

        // 指定した時間までexpectationのfulfillされるのを待つ
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
