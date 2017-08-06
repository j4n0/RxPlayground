
import RxSwift

exampleOf("Side effects: do(onNext:)")
{
    // Performs an action when a next event happens.
    // There is also do(onError:) and do(onCompleted:).
    _ = Observable.of(1,2,3,4,5)
        .do(onNext: { e in print("x") })
        .subscribe { print($0) }
}

exampleOf("Transformation: flatMap")
{
    // flatMap merges several sequences into one
    let s1  = Observable<Int>.of(1,2)
    let s2  = Observable<Int>.of(3,4)
    let sequenceOfSequences = Observable.of(s1,s2)
    sequenceOfSequences
        .flatMap{ return $0 }
        .subscribe { print($0) } // 1 2 3 4
}

exampleOf("Transformation: flatMapLatest")
{
    /*
     let o1 = PublishSubject<Int>()
     let o2  = PublishSubject<Int>()
     let o3  = PublishSubject<Int>()
     let sequences = Observable.of(o1, o2, o3)
     sequences
     .flatMapLatest { return $0 }
     .subscribe { print(#line, $0) } // 4 6 --- i dont understand why not 1246 <----
     o1.onNext(1)
     o2.onNext(2)
     o1.onNext(3)
     o3.onNext(4)
     o2.onNext(5)
     o3.onNext(6)
     */
    
    // flatMapLatest merges several sequences into one and ignores all but the latest sequence
    struct Player { let score: Variable<Int> }
    let scott = Player(score: Variable(80))
    let lori = Player(score: Variable(90))
    let player = Variable(scott)
    player
        .asObservable()
        .flatMapLatest { $0.score.asObservable() }
        .subscribe { print($0) }
    
    player.value.score.value = 85 // change on scott 85
    scott.score.value = 88        // change on scott 88
    player.value = lori           // change to lori  90
    scott.score.value = 95        // change on scott 95
    
    // flatMap       prints 80 85 88 90 95 because flatMap doesn’t unsubscribe from previous sequences
    // flatMapLatest prints 80 85 88 90    because we are only subscribed to the latest sequence (lori)
}

exampleOf("Transformation: map")
{
    // map transforms sequences
    _ = Observable<Int>
        .of(1,2,3)
        .map { return $0 * 10 }
        .subscribe { print($0) } // 10 20 30
}

exampleOf("Transformation: mapWithIndex")
{
    // mapWithIndex is a map with access to the index of the element
    // Other operators also have a WithIndex variant.
    _ = Observable<Int>
        .of(1,2,3)
        .mapWithIndex { index, integer in return integer * 10 }
        .subscribe { print($0) } // 10 20 30
}

exampleOf("Transformation: scan")
{
    // scan is rx version of reduce
    _ = Observable.of(1,2,3)
        .scan(0) { seed, value in return seed + value }
        .subscribe { print($0) } // 1 3 6
}

exampleOf("Transformation: window")
{
    // period­ically subdivide items into Observ­ables

}

