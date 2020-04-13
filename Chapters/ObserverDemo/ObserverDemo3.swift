enum Event<Element> {
    case next(Element)
    case completed
}

// MARK: - Observer

// 1. NEW: プロトコルとしてonメソッドを備えることを定義する
protocol ObserverType {
    associatedtype Element
    func on(_ event: Event<Element>)
}

// 2. UPDATE: ObserverTypeを準拠する形に変える
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

    // 3. UPDATE: Generic Where ClausesとしてElementが同一である制約を課します
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

    // 3. UPDATE: Generic Where ClausesとしてElementが同一である制約を課します
    override func subscribe<Observer: ObserverType>(_ observer: Observer)
        where Observer.Element == Element {
        observer.on(.next(element))
        observer.on(.completed)
    }
}

// MARK: - Operator

extension Observable {
    static func just(_ element: Element) -> Observable {
        Just(element: element)
    }
}
