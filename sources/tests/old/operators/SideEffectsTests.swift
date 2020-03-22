import RxCocoa
import RxSwift
import UIKit
import XCTest

class SideEffectsTests: XCTestCase {

    func testDoOnNext()
    {
        // Performs an action when a next event happens.
        // There is also do(onError:) and do(onCompleted:).
        _ = Observable.of(1, 2, 3, 4, 5)
            .do(onNext: { e in print("\(e)") })
            .subscribe { print($0) }
    }
    
    func testDebug()
    {
        // debug prints the given string plus extra info about the observable
        class Foo {
            let bag = DisposeBag()
            func bar(){
                UIButton().rx.tap
                    .debug("button tap")
                    .scan(0) { priorValue, _ in priorValue + 1 }
                    .subscribe(onNext: { [weak self] counter in self?.buzz(times: counter) })
                    .disposed(by: bag)
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
}
