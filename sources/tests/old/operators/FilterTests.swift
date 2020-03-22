import RxSwift
import XCTest

class FilterTests: XCTestCase {

    func testDebounce()
    {
        // debounce lets the event go through after the caller stops calling the function and the specific period elapses
        let bag = DisposeBag()
        UIButton().rx.tap
            .asDriver()
            .throttle(.seconds(2))
            .drive(onNext: { _ in print("Tap!") })
            .disposed(by: bag)
    }
    
    func testDistinctUntilChanged()
    {
        // distinctUntilChanged filters out elements which are the same as the previous one
        _ = Observable.of(1, 2, 2, 1, 3)
            .distinctUntilChanged()
            .subscribe { print($0) } // 1 2 1 3
    }
    
    func testElementAt()
    {
        // elementAt ignores all elements except the one at the given index
        _ = Observable
            .of(1, 2, 3, 4, 5)
            .elementAt(2)
            .subscribe { print($0) } // 3
    }
    
    func testFilter()
    {
        // filter discards events that don’t match the condition
        _ = Observable
            .of(2, 30, 22, 5, 60, 1)
            .filter{ $0 > 10 }
            .subscribe { print($0) } // 30 22 60
    }
    
    func testIgnoreElements()
    {
        // ignoreElements ignores all next events
        _ = Observable<Int>
            .of(1, 2, 3)
            .ignoreElements()
            .subscribe { print($0) } // completed
    }
    
    func testSkip()
    {
        _ = Observable.of("A", "B", "C", "D", "E", "F")
            .skip(3)
            .subscribe { print($0) } // D E F
    }
    
    func testSkipUntil()
    {
        // skipUntil skips until the observable parameters emits anything
        let subject = PublishSubject<String>()
        let trigger = PublishSubject<String>()
        _ = subject
            .skipUntil(trigger) // it will emit until 'trigger' emits anything
            .subscribe { print($0) }
    }
    
    func testSkipWhile()
    {
        // skipWhile skips elements for which the condition is true
        _ = Observable.of(1, 2, 3, 4)
            .skipWhile { $0 < 3 }
            .subscribe { print($0) } // 3 4
    }
    
    func testTake()
    {
        // take passes the number of events in the parameter and skips the rest
        _ = Observable.of(1, 2, 3, 4)
            .take(2)
            .subscribe { print($0) } // 1 2
    }
    
    func testTakeWhile()
    {
        // takeWhile emits events until the condition is false
        // there is a takeWhileWithIndex variant that also passes the index
        _ = Observable.of(1, 2, 3, 4)
            .takeWhile { $0 < 3 }
            .subscribe { print($0) } // 1 2
    }
    
    func testThrottle()
    {
        // throttle lets the event go through at most once per specific period
        let bag = DisposeBag()
        UIButton()
            .rx.tap
            .asDriver()
            .throttle(.seconds(2))
            .drive(onNext: { _ in print("Tap!") })
            .disposed(by: bag)
    }
}
