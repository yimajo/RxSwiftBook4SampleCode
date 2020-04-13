//// 1. NEW: structからclassにしてJustが継承するため変数を減らす
//class Observable<Element> {
//    // 2. NEW: extensionだとOverrideできないので
//    func subscribe(
//        onNext: ((Element) -> ())? = nil,
//        onCompleted: (() -> ())? = nil
//    ) {
//        fatalError("subscribeが不適切に使用された")
//    }
//}
//
//// 2. NEW: Justの型を作る
//class Just<Element>: Observable<Element> {
//    private let element: Element
//
//    init(element: Element) {
//        self.element = element
//    }
//
//    override func subscribe(
//        onNext: ((Element) -> ())? = nil,
//        onCompleted: (() -> ())? = nil
//    ) {
//        onNext?(element)
//        onCompleted?()
//    }
//}
//
//// MARK: - Operator
//
//extension Observable {
//    static func just(_ element: Element) -> Observable {
//        // 3. UPDATE: Justのインスタンスを作成して返す
//        Just(element: element)
//    }
//}
//
