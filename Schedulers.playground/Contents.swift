
import RxSwift

/*
To use schedulers use
  - observeOn   Affects where events are received
  - subscribeOn Affects where the subscription operates
*/

exampleOf("Schedulers: MainScheduler")
{
}

exampleOf("Schedulers: CurrentThreadScheduler")
{
}

exampleOf("Schedulers: SerialDispatchQueueScheduler")
{
}

exampleOf("Schedulers: ConcurrentDispatchQueueScheduler")
{
    let publish1 = PublishSubject<Int>()
    let publish2 = PublishSubject<Int>()
    let concurrentScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
    Observable.of(publish1,publish2)
        .observeOn(concurrentScheduler)
        .merge()
        .subscribeOn(MainScheduler())
        .subscribe { print($0) } // 20 40
    publish1.onNext(20)
    publish1.onNext(40)
}

exampleOf("Schedulers: OperationQueueScheduler")
{
}


