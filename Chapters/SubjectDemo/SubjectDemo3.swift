enum Event<Element> {
    case next(Element)
    case completed
}

// MARK: - Observer

protocol ObserverType {
    associatedtype Element
    func on(_ event: Event<Element>)
}

struct AnyObserver<Element>: ObserverType {
    // NEW:
    typealias BagType = Bag<(Event<Element>) -> ()>

    private let eventHandler: (Event<Element>) -> ()

    init(eventHandler: @escaping (Event<Element>) -> ()) {
        self.eventHandler = eventHandler
    }

    func on(_ event: Event<Element>) {
        eventHandler(event)
    }
}

class Sink<Observer: ObserverType> {
    private let observer: Observer

    init(observer: Observer) {
        self.observer = observer
    }

    final func forwardOn(_ event: Event<Observer.Element>) {
        observer.on(event)
    }
}

// MARK: - Observable

class Observable<Element> {
    func subscribe(
        onNext: ((Element) -> ())? = nil,
        onCompleted: (() -> ())? = nil
    ) {
        let observer = AnyObserver<Element> { event in
            switch event {
            case .next(let value):
                onNext?(value)
            case .completed:
                onCompleted?()
            }
        }

        subscribe(observer)
    }

    func subscribe<Observer: ObserverType>(_ observer: Observer)
        where Observer.Element == Element {
        preconditionFailure("このメソッドが呼ばれると実装ミス")
    }
}

class Just<Element>: Observable<Element> {
    private let element: Element

    init(element: Element) {
        self.element = element
    }

    override func subscribe<Observer: ObserverType>(_ observer: Observer)
        where Observer.Element == Element {
        observer.on(.next(element))
        observer.on(.completed)
    }
}

class ObservableSequence<Sequence: Swift.Sequence, Element>: Observable<Element> {
    let elements: Sequence

    init(elements: Sequence) {
        self.elements = elements
    }

    override func subscribe<Observer: ObserverType>(_ observer: Observer)
        where Observer.Element == Element {
        let sink = ObservableSequenceSink(parent: self, observer: observer)
        sink.run()
    }

    private class ObservableSequenceSink<Sequence: Swift.Sequence,
                                         Observer: ObserverType,
                                         Element>
        : Sink<Observer> {

        private let parent: ObservableSequence<Sequence, Element>

        init(parent: ObservableSequence<Sequence, Element>, observer: Observer) {
            self.parent = parent
            super.init(observer: observer)
        }

        func run() {
            parent.elements.forEach { element in
                if let element = element as? Observer.Element {
                    forwardOn(.next(element))
                }
            }

            forwardOn(.completed)
        }
    }
}

// MARK: - Operator

extension Observable {
    static func just(_ element: Element) -> Observable {
        Just(element: element)
    }
}

extension Observable {
    static func of(_ elements: Element ...) -> Observable<Element> {
        ObservableSequence(elements: elements)
    }
}

extension Observable {
    func map(
        _ handler: (@escaping (_ element: Element) -> Element)
    ) -> Observable<Element> {

        Map(source: self, transform: handler)
    }
}

class Map<SourceType, ResultType>: Observable<ResultType> {
    typealias Element = ResultType
    typealias Transform = (SourceType) -> ResultType

    private let source: Observable<SourceType>
    private let transform: Transform

    init(source: Observable<SourceType>, transform: @escaping Transform) {
        self.source = source
        self.transform = transform
    }

    override func subscribe<Observer: ObserverType>(_ observer: Observer)
        where Observer.Element == Element {
        let sink = MapSink(transform: transform, observer: observer)
        source.subscribe(sink)
    }

    private class MapSink<SourceType, Observer: ObserverType>
        : Sink<Observer>, ObserverType {

        typealias Transform = (SourceType) throws -> ResultType

        typealias ResultType = Observer.Element

        private let transform: Transform

        init(transform: @escaping Transform, observer: Observer) {
            self.transform = transform
            super.init(observer: observer)
        }

        // subscribeさせられるとonメソッドが呼び出される
        func on(_ event: Event<SourceType>) {
            switch event {
            case .next(let element):
                // NEW: クロージャを処理してobserverにonしてイベントを伝える
                let mappedElement = try! self.transform(element)
                forwardOn(.next(mappedElement))
            case .completed:
                forwardOn(.completed)
            }
        }
    }
}

// MARK: - Bag

struct Bag<T> {
    private(set) var dictionary: [UInt64: T]?
    private var _nextKey = 0

    mutating func insert(_ element: T) {
        let key = _nextKey

        _nextKey = _nextKey + 1

        if let _ = dictionary {
            dictionary![UInt64(key)] = element
        } else {
            dictionary = [UInt64(key): element]
        }
    }
}

// MARK: - Subject

class PublishSubject<Element>: Observable<Element>, ObserverType {

    // NEW: Observerを配列で引き連れているのでその型をエリアスしておく
    typealias Observers = AnyObserver<Element>.BagType

    private var observers = Observers()

    override func subscribe<Observer: ObserverType>(_ observer: Observer)
        where Observer.Element == Element {
        observers.insert(observer.on)
    }

    func on(_ event: Event<Element>) {
        dispatch(observers, event)
    }

    private func dispatch(_ observers: Observers, _ event: Event<Element>) {
        guard let values = observers.dictionary?.values else {
            return
        }

        for handler: (Event<Element>) -> () in values {
            handler(event)
        }
    }
}

