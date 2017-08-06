
import UIKit
import RxCocoa
import RxSwift

exampleOf("Side effects: do(onNext:)")
{
    // Performs an action when a next event happens.
    // There is also do(onError:) and do(onCompleted:).
    _ = Observable.of(1,2,3,4,5)
        .do(onNext: { e in print("x") })
        .subscribe { print($0) }
}

exampleOf("Side effects: debug")
{
    // debug prints the given string plus extra info about the observable
    class Foo {
        let bag = DisposeBag()
        func bar(){
            UIButton().rx.tap
                .debug("button tap")
                .scan(0) { (priorValue, _) in return priorValue + 1 }
                .subscribe(onNext: { [unowned self] counter in self.buzz(times: counter) })
                .addDisposableTo(bag)
        }
        func buzz(times: Int){ print("you tapped \(times) times") }
    }
}

/*
 debug output:
 
 2016-12-15 19:02:31.396: button tap -> subscribed
 2016-12-15 19:02:34.045: button tap -> Event next(())
 2016-12-15 19:02:34.584: button tap -> Event next(())
 2016-12-15 19:02:35.161: button tap -> Event next(())
 */
