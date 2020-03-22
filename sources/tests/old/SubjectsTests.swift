import RxCocoa
import RxSwift
import XCTest

class SubjectsTests: XCTestCase
{
    // print the element if there is one, or else an error if there is one, or else the event itself
    func printEvent<T: CustomStringConvertible>(label: String, event: Event<T>) {
        Swift.print(label, event)
    }
    
    /*:
     A **subject** is a special form of an Observable Sequence, you can subscribe and dynamically add elements to it.
     There are currently four kinds:
     
     - `PublishSubject`: Sends events happening after subscription.
     - `BehaviorSubject`: Sends the most recent event and any event happening after subscription.
     - `ReplaySubject`: Sends a configurable number of recent events.
     - `Variable`: Wraps a BehaviorSubject, preserves its current value as state, and replays the latest value.
     */
    
    func testPublishSubject()
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
    
    func testBehaviorSubject()
    {
        // BehaviorSubject sends the most recent event and any event happening after subscription.
        let subject = BehaviorSubject<String>(value: "pottery")
        subject.onNext("Hello")
        _ = subject.subscribe { print($0) } // Hello World
        subject.onNext("World")
    }
    
    func testReplaySubject()
    {
        // ReplaySubject sends a configurable number of recent events.
        let subject = ReplaySubject<Int>.create(bufferSize: 2)
        subject.onNext(1)
        subject.onNext(2)
        subject.onNext(3)
        subject.onNext(4)
        _ = subject.subscribe { self.printEvent(label: "replaysubject: ", event: $0) } // 3 4
    }
    
    func testVariable()
    {
        // Variable is a ReplaySubject that can be used as a normal variable.
        let subject = BehaviorRelay<Int>(value: 0)
        _ = subject.asObservable().subscribe { print($0) } // 0 completed
        
        /*
         Adding error or completed events to a variable generate compiler errors.
         The following are compiler errors:
         variable.value.onError(MyError.anError)
         variable.asObservable().onError(MyError.anError)
         variable.value = MyError.anError
         variable.value.onCompleted()
         variable.asObservable().onCompleted()
         */
        
        let a = BehaviorRelay<Int>(value: 1)
        let b = BehaviorRelay<Int>(value: 1)
        let c = Observable.combineLatest(a.asObservable(), b.asObservable()) { $0 + $1 }
        _ = c.subscribe { Swift.print("c = \($0)") }
        a.value.accept(10)
    }
}
