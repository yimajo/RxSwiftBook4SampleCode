//struct Observable {
//    // NEW: 値を保持させてそれそのまま返すだけ
//    let element: Int
//}
//
//extension Observable {
//    static func just(_ element: Int) -> Observable {
//        // UPDATE: Observableを作って返す
//        Observable(element: element)
//    }
//}
//
//extension Observable {
//      func subscribe(onNext: ((Int) -> ())? = nil) {
//        // UPDATE: クロージャにelementを渡すだけ
//        onNext?(element)
//    }
//}
