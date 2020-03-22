import RxSwift
import XCTest

// swiftlint:disable empty_xctest_method
class SchedulersTests: XCTestCase {

    /*
     To use schedulers use
     - observeOn   Affects where events are received
     - subscribeOn Affects where the subscription operates
     */
    
    func testMainScheduler() {}
    func testCurrentThreadScheduler() {}
    func testSerialDispatchQueueScheduler() {}
    
    func testConcurrentDispatchQueueScheduler()
    {
        let publish1 = PublishSubject<Int>()
        let publish2 = PublishSubject<Int>()
        let concurrentScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        _ = Observable.of(publish1, publish2)
            .observeOn(concurrentScheduler)
            .merge()
            .subscribeOn(MainScheduler())
            .subscribe { print($0) } // 20 40
        publish1.onNext(20)
        publish1.onNext(40)
    }
    
    func testOperationQueueScheduler() {}
}
