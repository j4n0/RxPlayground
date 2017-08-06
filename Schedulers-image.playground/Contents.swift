
import Foundation
import RxSwift
import UIKit
import PlaygroundSupport

let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 128.0, height: 128.0))
let swift = UIImage(named: "Swift")!
let swiftImageData = UIImagePNGRepresentation(swift)!

let disposeBag = DisposeBag()
let imageDataSubject = PublishSubject<NSData>()

imageDataSubject
    .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    .map { UIImage(data: $0 as Data) }
    .observeOn(MainScheduler.instance)
    .subscribe { imageView.image = $0.element! }
    .addDisposableTo(disposeBag)

imageDataSubject.onNext(swiftImageData as NSData)

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = imageView


/*
  The following is another way of writing the background processing. It creates a serial initializer which uses a concurrent queue to do  the work, but still returns the work through a serial proxy. The difference is that this also works on the background, but it returns the work in the order it was submitted.
 
      let queue = DispatchQueue(label: "com.jano.my.stupid.queue")
      let scheduler = SerialDispatchQueueScheduler(queue: queue, internalSerialQueueName: "com.jano.mySerialQueue")
      imageDataSubject.observeOn(scheduler)...

  And here is another, this time using a NSOperationQueue running on the background.

    let operationQueue = NSOperationQueue()
    operationQueue.maxConcurrentOperationCount = 3
    operationQueue.qualityOfService = NSQualityOfService.UserInitiated
    let backgroundWorkScheduler = OperationQueueScheduler(operationQueue: operationQueue)
    imageDataSubject.observeOn(scheduler)...
*/





