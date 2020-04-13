import XCTest
@testable import SubjectDemo

class SubjectDemoTests: XCTestCase {

    var expect: XCTestExpectation!

    override func setUp() {
        expect = expectation(description: "")
        // 1. NEW: 2つのObserverのonCompletedが呼び出されたか検証
        expect.expectedFulfillmentCount = 2
    }

    func test() throws {
        // 2. NEW: Intを通知するSubjectとする
        let subject = PublishSubject<Int>()
        // 3. NEW: 結果を追加するArrayを2つ
        var arrayA: [Int] = []
        var arrayB: [Int] = []

        XCTContext.runActivity(named: "Subjectのイベント発生前にsubscribe") { _ in
            let observer = AnyObserver<Int> {
                switch $0 {
                case .next(let element):
                    arrayA.append(element)
                case .completed:
                    XCTAssertEqual(arrayA, [1, 2, 3])
                    self.expect.fulfill()
                }
            }
            subject.subscribe(observer)
        }

        // 4. NEW: 最初のイベントを伝える
        subject.on(.next(1))

        XCTContext.runActivity(named: "Subjectの1イベント発生後にsubscribe") { _ in
            // NEW: 5. イベントが流れたあとにsubscribeさせる
            subject.subscribe(onNext: {
                arrayB.append($0)
            }, onCompleted: {
                XCTAssertEqual(arrayB, [2, 3])
                self.expect.fulfill()
            })
        }

        // 6. NEW: 2つ目のObserverがsubscribe後に続けてイベント発生
        subject.on(.next(2))
        subject.on(.next(3))
        subject.on(.completed)

        waitForExpectations(timeout: 0.1, handler: nil)
    }
}

