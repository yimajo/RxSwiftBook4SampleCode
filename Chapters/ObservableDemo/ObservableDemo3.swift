//// UPDATE: ジェネリクスとして型パラメータをElementを指定
//struct Observable<Element> {
//    let element: Element // UPDATE: 変数の型をElementとする
//}
//
//extension Observable {
//    // UPDATE: 型をElementに変更
//    static func just(_ element: Element) -> Observable {
//        Observable(element: element)
//    }
//}
//
//extension Observable {
//    // UPDATE: 型をElementに変更
//    func subscribe(onNext: ((Element) -> ())? = nil) {
//        onNext?(element)
//    }
//}
//
