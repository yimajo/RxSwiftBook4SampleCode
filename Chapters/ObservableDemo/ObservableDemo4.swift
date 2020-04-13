//struct Observable<Element> {
//    let element: Element
//}
//
//extension Observable {
//    static func just(_ element: Element) -> Observable {
//        Observable(element: element)
//    }
//}
//
//extension Observable {
//    // 1. UPDATE: 引数にonCompletedクロージャの引数を増やした
//    func subscribe(
//        onNext: ((Element) -> ())? = nil,
//        onCompleted: (() -> ())? = nil
//    ) {
//        onNext?(element)
//        // 2. NEW: そのまま終了流すだけ
//        onCompleted?()
//    }
//}
