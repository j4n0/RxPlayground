
import RxSwift
import UIKit
import RxSwift
import RxCocoa
import PlaygroundSupport

// Thread.sleep(forTimeInterval: 1.0)

PlaygroundPage.current.needsIndefiniteExecution = true

exampleOf("Time-based: buffer")
{
    // buffer returns an observable that returns events when full or after an elapsed time
    let startDelay = DispatchTimeInterval.seconds(0)
    let intervalDelay = DispatchTimeInterval.seconds(1)
    let precisionTolerance = DispatchTimeInterval.seconds(1)
    let queue = DispatchQueue(label: "Concurrent", attributes: [], target: nil)
    let timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: UInt(0)), queue: queue)
    let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)
    var counter = 0
    _ = Observable<Int>.create { observer in
        timer.schedule(deadline: .now() + startDelay, repeating: intervalDelay, leeway: precisionTolerance)
        timer.setEventHandler() {
            observer.onNext(counter)
            counter = counter + 1
            if counter > 10 { observer.onCompleted() }
        }
        timer.resume()
        return Disposables.create { timer.suspend() }
        }
        .buffer(timeSpan: 4, count: 3, scheduler: scheduler)
        .subscribe { print("> \($0)") }
}


exampleOf("Time-based: delaySubscription")
{
    // delaySubscription delays the subscription from happening
    let delayInSeconds = 1
    _ = Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
        .delaySubscription(RxTimeInterval(delayInSeconds), scheduler: MainScheduler.instance)
        .subscribe { print("% \($0)") }
}

exampleOf("Time-based: interval")
{
    // interval increments an Int from 0 every n seconds
    _ = Observable<Int>.interval(1, scheduler: MainScheduler.instance).subscribe {
        print("interval: \($0)")
    }
}

exampleOf("Time-based: replay")
{
    // replay returns a connectable sequence that replays a number of events from the sequence it connects to
    let observable = Observable.of(1, 2, 3)
    let connectable = observable.replay(2)
    connectable.connect()
    
    observable.subscribe { print($0) }         // 1 2 3 completed
    connectable.subscribe { print("- \($0)") } // 2 3 completed
}

exampleOf("Time-based: replayAll")
{
    // replayAll returns a connectable sequence that replays all events from the sequence it connects to
    let observable = Observable.of(1, 2, 3)
    let connectable = observable.replayAll()
    connectable.connect()
    
    observable.subscribe { print($0) }         // 1 2 3 completed
    connectable.subscribe { print("- \($0)") } // 1 2 3 completed
}

exampleOf("Time-based: multicast")
{
    // let observable = Observable.of(1, 2, 3).multicast()
}

exampleOf("Time-based: publish")
{
    // convert an ordinary Observable into a connec­table Observable
    // let observable = Observable.of(1, 2, 3).publish()
}

exampleOf("Time-based: retry")
{
    // retry request until there is a non error event
    _ = Observable<HTTPURLResponse>.create { observer in
            // execute request
            return Disposables.create() {
                // request.cancel()
            }
        }.retry(3)
    
    // to repeat with exponential delay you need RxSwiftExt. For instance, here is a retry that happens at seconds 2,4,8
    // retry(.exponentialDelayed(maxCount: 3, initial: 2, multiplier: 1))
}

