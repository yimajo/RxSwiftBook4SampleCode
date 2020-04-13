//// 1. NEW: Eventを型として要素と完了を網羅する
//enum Event<Element> {
//    case next(Element)
//    case completed
//}
//
//// 2. NEW: 監視時のイベントを保持しイベント検知時にイベントを実行する型を作る
//struct AnyObserver<Element> {
//    // 監視時のイベントを保持
//    private let eventHandler: (Event<Element>) -> ()
//
//    init(eventHandler: @escaping (Event<Element>) -> ()) {
//        self.eventHandler = eventHandler
//    }
//
//    func on(_ event: Event<Element>) {
//        // イベントを検知すると監視時のイベントを実行させる
//        eventHandler(event)
//    }
//}
//
//class Observable<Element> {
//    func subscribe(
//        onNext: ((Element) -> ())? = nil,
//        onCompleted: (() -> ())? = nil
//    ) {
//        fatalError("subscribeが不適切に使用された")
//    }
//
//    // 3. NEW: ObservableをObserverでsubscribeするメソッド
//    func subscribe(_ observer: AnyObserver<Element>) {
//        preconditionFailure("このメソッドが呼ばれると実装ミス")
//    }
//}
//
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
//
//    // 4. NEW: ObservableをObserverでsubscribeするメソッド
//    override func subscribe(_ observer: AnyObserver<Element>) {
//        observer.on(.next(element))
//        observer.on(.completed)
//    }
//}
//
//// MARK: - Operator
//
//extension Observable {
//    static func just(_ element: Element) -> Observable {
//        Just(element: element)
//    }
//}
