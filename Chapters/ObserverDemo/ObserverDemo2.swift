//enum Event<Element> {
//    case next(Element)
//    case completed
//}
//
//struct AnyObserver<Element> {
//    private let eventHandler: (Event<Element>) -> ()
//
//    init(eventHandler: @escaping (Event<Element>) -> ()) {
//        self.eventHandler = eventHandler
//    }
//
//    func on(_ event: Event<Element>) {
//        eventHandler(event)
//    }
//}
//
//// MARK: - Observable
//
//class Observable<Element> {
//    func subscribe(
//        onNext: ((Element) -> ())? = nil,
//        onCompleted: (() -> ())? = nil
//    ) {
//        // 1. UPDATE: subscibeメソッド内部でAnyObserverを作りイベントを繋げさせる
//        let observer = AnyObserver<Element> { event in
//            switch event {
//            case .next(let value):
//                onNext?(value)
//            case .completed:
//                onCompleted?()
//            }
//        }
//
//        subscribe(observer)
//    }
//
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
