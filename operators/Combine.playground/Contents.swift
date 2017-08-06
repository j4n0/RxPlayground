
import RxSwift

exampleOf("Combine: amb")
{
    // The idiom created with this operator is known as switch.
    // 'amb' comes from ambiguity (you don’t know from which one we’ll get events), but it would be better called 'switchToFirst'.
    let fruits = PublishSubject<String>()
    let cities = PublishSubject<String>()

    let observable = fruits.amb(cities)
    let disposable = observable.subscribe { print($0) }
    
    fruits.onNext("apple")
    cities.onNext("Copenhagen")
    fruits.onNext("orange")
    fruits.onNext("pear")
    cities.onNext("Vienna")
    
    disposable.dispose()
}

exampleOf("Combine: concat")
{
    // concat to an observable
    let numbers = Observable.of(1, 2, 3)
    _ = Observable
        .just(0)
        .concat(numbers)
        .subscribe { print($0) } // 0 1 2 3 completed
    
    // create an observable from a sequence of sequences
    let first = Observable.of(1, 2, 3)
    let second = Observable.of(4, 5, 6)
    _ = Observable
        .concat([first, second])
        .subscribe { print($0) }
}

exampleOf("Combine: combineLatest")
{
    let left = PublishSubject<String>()
    let right = PublishSubject<String>()
    _ = Observable
        .combineLatest(left, right, resultSelector: { lastLeft, lastRight in
            "\(lastLeft) \(lastRight)"
        }).subscribe { print($0) }
    
    left.onNext("Hello")
    right.onNext("Alice")
    right.onNext("Bob")
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

exampleOf("Combine: reduce")
{
    // reduces a sequence and produces a single element
    let source = Observable.of(1, 3, 5, 7, 9)
    let observable = source.reduce(0, accumulator: +)
    observable.subscribe { print($0) }
}

exampleOf("Combine: startWith")
{
    // startWith causes a sequence to start emitting certain events before its own events.
    _ = Observable.of(2,3)
        .startWith(1)
        .startWith(8,9)
        .subscribe { print($0) } // 8 9 1 2 3
}

exampleOf("withLatestFrom")
{
    // withLatestFrom returns an element from a different sequence each time the sequence emits an event.
    // The idiom created with this operator is known as 'trigger'.
    let button = PublishSubject<String>()
    let textField = PublishSubject<String>()
    _ = button
        .withLatestFrom(textField)
        .subscribe { print($0) }
    textField.onNext("Par")
    textField.onNext("Pari")
    textField.onNext("Paris")
    button.onNext("clicked")
}

exampleOf("Combine: switchToLatest")
{
    // subscribes to a sequence of observables and relays the events of the sequence which has been emitted last
    
    let one = PublishSubject<String>()
    let two = PublishSubject<String>()
    let three = PublishSubject<String>()
    
    let source = PublishSubject<Observable<String>>()
    
    let observable = source.switchLatest()
    let disposable = observable.subscribe { print($0) } // 1 3 7 8
    
    source.onNext(one) // now relaying events from sequence one

    one.onNext("1")
    two.onNext("2")
    source.onNext(two) // now relaying events from sequence two
    two.onNext("3")
    one.onNext("4")
    source.onNext(three)  // now relaying events from sequence three
    two.onNext("5")
    one.onNext("6")
    three.onNext("7")
    source.onNext(one)  // now relaying events from sequence one
    one.onNext("8")
    disposable.dispose()
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


