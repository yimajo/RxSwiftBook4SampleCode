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

// 1. NEW: ofオペレータにより作成されるObservableSequence
class ObservableSequence<Sequence: Swift.Sequence, Element>: Observable<Element> {
    let elements: Sequence

    init(elements: Sequence) {
        self.elements = elements
    }

    override func subscribe<Observer: ObserverType>(_ observer: Observer)
        where Observer.Element == Element {
        // 2. NEW: 保持している要素をループさせobserverへ通知し、最後に完了を流す
        elements.forEach { element in
            if let element = element as? Observer.Element {
                observer.on(.next(element))
            }
        }

        observer.on(.completed)
    }
}

// MARK: - Operator

extension Observable {
    static func just(_ element: Element) -> Observable {
        Just(element: element)
    }
}

extension Observable {
    // 3. NEW: ofオペレータを作りObservableSequenceを返してもらう
    static func of(_ elements: Element ...) -> Observable<Element> {
        ObservableSequence(elements: elements)
    }
}

