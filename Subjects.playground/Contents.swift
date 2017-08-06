
import RxSwift

// print the element if there is one, or else an error if there is one, or else the event itself
func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
    print(label, event.element ?? event.error ?? event)
}

/*:
 A **subject** is a special form of an Observable Sequence, you can subscribe and dynamically add elements to it.
 There are currently four kinds:
 
 - `PublishSubject`: Sends events happening after subscription.
 - `BehaviorSubject`: Sends the most recent event and any event happening after subscription.
 - `ReplaySubject`: Sends a configurable number of recent events.
 - `Variable`: Wraps a BehaviorSubject, preserves its current value as state, and replays the latest value.
 */

exampleOf("PublishSubject")
{
    // PublishSubject sends events happening after subscription.
    let bag = DisposeBag()
    let subject = PublishSubject<String>()
    subject.onNext("one")
    subject.subscribe { print($0) }.disposed(by: bag) // two three
    subject.onNext("two")
    subject.on(.next("three"))
    subject.on(.completed)
    
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
    subject.subscribe { print(label: "replaysubject: ", event: $0) } // 3 4
}

exampleOf("Variable")
{
    // Variable is a ReplaySubject that can be used as a normal variable.
    let subject = Variable<Int>(0)
    subject.asObservable().subscribe { print($0) } // 0 completed

    /*
    Adding error or completed events to a variable generate compiler errors.
    The following are compiler errors:
        variable.value.onError(MyError.anError)
        variable.asObservable().onError(MyError.anError)
        variable.value = MyError.anError
        variable.value.onCompleted()
        variable.asObservable().onCompleted()
    */
    
    let a = Variable(1)
    let b = Variable(1)
    let c = Observable.combineLatest(a.asObservable(), b.asObservable()) { $0 + $1 }
    c.subscribe { print("c = \($0)") }
    a.value = 10
}

