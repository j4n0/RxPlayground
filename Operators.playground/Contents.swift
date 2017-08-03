
import RxSwift

exampleOf("Transformation: buffer")
{
    // buffer returns an observable that returns events when full or after a defined elapsed time.
    // In this example, it sends the buffer after 150ms or when its capacity is 3.
    let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)
    Observable.of(1,2,3) // MISSING EXAMPLE, use a gcd timer to send values at intervals
        .buffer(timeSpan: 150, count: 3, scheduler: scheduler)
        .subscribe { print($0) }
}

exampleOf("Filter: distinctUntilChanged")
{
    // distinctUntilChanged filters out elements which are the same as the previous one
    _ = Observable.of(1,2,2,1,3)
        .distinctUntilChanged()
        .subscribe { print($0) } // 1 2 1 3
}

exampleOf("Side effects: do(onNext:)")
{
    // Performs an action when a next event happens.
    // There is also do(onError:) and do(onCompleted:).
    _ = Observable.of(1,2,3,4,5)
        .do(onNext: { e in print("x") })
        .subscribe { print($0) }
}

exampleOf("Filter: elementAt")
{
    // elementAt ignores all elements except the one at the given index
    _ = Observable
        .of(1,2,3,4,5)
        .elementAt(2)
        .subscribe { print($0) } // 3
}

exampleOf("Filter: filter")
{
    // filter discards events that don’t match the condition
    _ = Observable
        .of(2,30,22,5,60,1)
        .filter{$0 > 10}
        .subscribe { print($0) } // 30 22 60
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

exampleOf("Filter: ignoreElements")
{
    // ignoreElements ignores all next events
    _ = Observable<Int>
        .of(1,2,3)
        .ignoreElements()
        .subscribe { print($0) } // completed
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

exampleOf("Combine: merge")
{
    // merge combines multiple Observables into one.
    // This example subscribe to the result of merging two subjects.
    let s1 = PublishSubject<Int>()
    let s2 = PublishSubject<Int>()
    _ = Observable.of(s1, s2).merge().subscribe { print($0) } // 20 40 60 1 80 2 100
    s1.onNext(20)
    s1.onNext(40)
    s1.onNext(60)
    s2.onNext(1)
    s1.onNext(80)
    s2.onNext(2)
    s1.onNext(100)
}

exampleOf("Transformation: scan")
{
    // scan is rx version of reduce
    _ = Observable.of(1,2,3)
        .scan(0) { seed, value in return seed + value }
        .subscribe { print($0) } // 1 3 6
}

exampleOf("Filter: skip")
{
    Observable.of("A", "B", "C", "D", "E", "F")
        .skip(3)
        .subscribe { print($0) } // D E F
}

exampleOf("Filter: skipUntil")
{
    // skipUntil skips until the observable parameters emits anything
    let subject = PublishSubject<String>()
    let trigger = PublishSubject<String>()
    subject
        .skipUntil(trigger) // it will emit until 'trigger' emits anything
        .subscribe { print($0) }
}

exampleOf("Filter: skipWhile")
{
    // skipWhile skips elements for which the condition is true
    Observable.of(1,2,3,4)
        .skipWhile { $0 < 3 }
        .subscribe { print($0) } // 3 4
}

exampleOf("Combine: startWith")
{
    // startWith causes a sequence to start emitting certain events before its own events.
    _ = Observable.of(2,3)
        .startWith(1)
        .startWith(8,9)
        .subscribe { print($0) } // 8 9 1 2 3
}

exampleOf("Filter: take")
{
    // take passes the number of events in the parameter and skips the rest
    _ = Observable.of(1,2,3,4)
        .take(2)
        .subscribe { print($0) } // 1 2
}

exampleOf("Filter: takeWhile")
{
    // takeWhile emits events until the condition is false
    // there is a takeWhileWithIndex variant that also passes the index
    _ = Observable.of(1,2,3,4)
        .takeWhile { $0<3 }
        .subscribe { print($0) } // 1 2
}

exampleOf("Combine: zip")
{
    // zip takes two sequences and returns pair of elements, where each pair has an element from each sequence.
    // It will produce as many elements as the number of elements in the shortest sequence.
    Observable.zip(Observable.of(1,2,3,4,5), Observable.of("a","b","c")).subscribe { print($0) } // (1,a) (2,b) (3,c)
    
    let strings = PublishSubject<String>()
    let ints = PublishSubject<Int>()
    _ = Observable.zip(strings, ints) { string, integer in "\(string)\(integer)" }.subscribe { print($0) } // A1 B2
    strings.onNext("A")
    strings.onNext("B")
    ints.onNext(1)
    ints.onNext(2)
    strings.onNext("C")
}


