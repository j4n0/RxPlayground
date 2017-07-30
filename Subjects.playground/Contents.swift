
import RxSwift

/*:
 A **subject** is a special form of an Observable Sequence, you can subscribe and dynamically add elements to it.
 There are currently four kinds:
 
 - `PublishSubject`: Sends events happening after subscription.
 - `BehaviorSubject`: Sends the most recent event and any event happening after subscription.
 - `ReplaySubject`: Sends a configurable number of recent events.
 - `Variable`: A ReplaySubject that can be used as a normal variable.
 */

exampleOf("PublishSubject")
{
    // PublishSubject sends events happening after subscription.
    let subject = PublishSubject<String>()
    subject.onNext("Hello")
    subject.subscribe { print($0) } // World
    subject.onNext("World")
}

exampleOf("BehaviorSubject")
{
    // BehaviorSubject sends the most recent event and any event happening after subscription.
    let subject = BehaviorSubject<String>(value: "pottery")
    subject.onNext("Hello")
    subject.subscribe { print($0) } // Hello World
    subject.onNext("World")
}

exampleOf("ReplaySubject")
{
    // ReplaySubject sends a configurable number of recent events.
    let subject = ReplaySubject<Int>.create(bufferSize: 2)
    subject.onNext(1)
    subject.onNext(2)
    subject.onNext(3)
    subject.onNext(4)
    subject.subscribe { print($0) } // 3 4
}

exampleOf("Variable")
{
    // Variable is a ReplaySubject that can be used as a normal variable.
    let subject = Variable<Int>(0)
    subject.asObservable().subscribe { print($0) } // 0 completed
}


