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
    private let eventHandler: (Event<Element>) -> ()

    init(eventHandler: @escaping (Event<Element>) -> ()) {
        self.eventHandler = eventHandler
    }

    func on(_ event: Event<Element>) {
        eventHandler(event)
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
                                         Element> {
        private let parent: ObservableSequence<Sequence, Element>
        private let observer: Observer

        init(parent: ObservableSequence<Sequence, Element>, observer: Observer) {
            self.parent = parent
            self.observer = observer
        }

        func run() {
            parent.elements.forEach { element in
                  if let element = element as? Observer.Element {
                      observer.on(.next(element))
                  }
            }

            observer.on(.completed)
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

// 1. NEW: mapオペレータを作り専用のObservableであるMapを返す
extension Observable {
    func map(
        _ handler: (@escaping (_ element: Element) -> Element)
    ) -> Observable<Element> {
        // 外部から与える変換処理を行うクロージャはtransformという変数名とする
        Map(source: self, transform: handler)
    }
}

// 2. NEW: Mapの入力をSourceTypeとし結果をResultTypeとする
class Map<SourceType, ResultType>: Observable<ResultType> {
    typealias Element = ResultType
    // mapの入力と出力をTransformとする
    typealias Transform = (SourceType) -> ResultType

    // 上流
    private let source: Observable<SourceType>
    // 変換のクロージャ
    private let transform: Transform

    init(source: Observable<SourceType>, transform: @escaping Transform) {
        self.source = source
        self.transform = transform
    }

    override func subscribe<Observer: ObserverType>(_ observer: Observer)
        where Observer.Element == Element {
        // 3. NEW: MapSinkを作成し実処理を任せる
        let sink = MapSink(transform: transform, observer: observer)
        source.subscribe(sink)
    }

    // 4. NEW: MapSinkに上流を処理して下流のObserverにまかせるSink
    private class MapSink<SourceType, Observer: ObserverType>: ObserverType {
        typealias Element = SourceType
        // mapの入力と出力をTransformとしてfunction typeを決める
        typealias Transform = (SourceType) throws -> ResultType

        typealias ResultType = Observer.Element

        private let transform: Transform
        private let observer: Observer

        init(transform: @escaping Transform, observer: Observer) {
            self.transform = transform
            self.observer = observer
        }

        // subscribeさせられるとonメソッドが呼び出される
        func on(_ event: Event<SourceType>) {
            switch event {
            case .next(let element):
                // クロージャを処理してobserverにonしてイベントを伝える
                let mappedElement = try! self.transform(element)
                observer.on(.next(mappedElement))
            case .completed:
                observer.on(.completed)
            }
        }
    }
}
