struct Observable { }

extension Observable {
    static func just(_ element: Int) -> Observable {
        Observable() // 作って返すだけ
    }
}

extension Observable {
    func subscribe(onNext: ((Int) -> ())? = nil) {
        onNext?(2)  // 何やっても2が返る
    }
}
