//enum Event<Element> {
//    case next(Element)
//    case completed
//}
//
//// MARK: - Observer
//
//protocol ObserverType {
//    associatedtype Element
//    func on(_ event: Event<Element>)
//}
//
//struct AnyObserver<Element>: ObserverType {
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
//    func subscribe<Observer: ObserverType>(_ observer: Observer)
//        where Observer.Element == Element {
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
//    override func subscribe<Observer: ObserverType>(_ observer: Observer)
//        where Observer.Element == Element {
//        observer.on(.next(element))
//        observer.on(.completed)
//    }
//}
//
//class ObservableSequence<Sequence: Swift.Sequence, Element>: Observable<Element> {
//    let elements: Sequence
//
//    init(elements: Sequence) {
//        self.elements = elements
//    }
//
//    override func subscribe<Observer: ObserverType>(_ observer: Observer)
//        where Observer.Element == Element {
//        // 1. UPDATE: 詳細な実装は実行用のSinkに任せ、上流からのイベント要素を実行する
//        let sink = ObservableSequenceSink(parent: self, observer: observer)
//        sink.run()
//    }
//
//    // 2. NEW: Of用のシーケンスにあるイベントを実行するクラス
//    private class ObservableSequenceSink<Sequence: Swift.Sequence,
//                                         Observer: ObserverType,
//                                         Element> {
//        private let parent: ObservableSequence<Sequence, Element> // 元要素
//        private let observer: Observer // 下流のためのObserver
//
//        init(parent: ObservableSequence<Sequence, Element>, observer: Observer) {
//            self.parent = parent
//            self.observer = observer
//        }
//
//        func run() {
//            parent.elements.forEach { element in
//                if let element = element as? Observer.Element {
//                    observer.on(.next(element))
//                }
//            }
//
//            observer.on(.completed)
//        }
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
//
//extension Observable {
//    static func of(_ elements: Element ...) -> Observable<Element> {
//        ObservableSequence(elements: elements)
//    }
//}
//
