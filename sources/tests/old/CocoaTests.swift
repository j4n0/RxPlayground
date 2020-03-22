import XCTest

// swiftlint:disable empty_xctest_method
class CocoaTests: XCTestCase
{
    func testUITextField()
    {
        // fires when the user stops clicking
        let bag = DisposeBag()
        UITextField().rx.text
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribe { print("validate \($0)") }
            .disposed(by: bag)
    }
    
    func testDriverButtonToLabel()
    {
        class ViewController: UIViewController
        {
            @IBOutlet var label: UILabel!
            @IBOutlet var button: UIButton!
            private let bag = DisposeBag()
            override func viewDidLoad(){
                self.button.rx.tap
                    .scan(0) { priorValue, _ in priorValue + 1 }
                    .asDriver(onErrorJustReturn: 0)
                    .map { currentCount in "You have tapped that button \(currentCount) times." }
                    .drive(self.label.rx.text)
                    .disposed(by: bag)
            }
        }
    }
    
    func testUICollectionCellTap()
    {
        /*
         func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DummyCell", for: indexPath)
         cell.button.rx.tap
         .debounce(0.3, scheduler: MainScheduler.instance)
         .subscribe(onNext: { [unowned self] in
         print(indexPath)
         }).addDisposableTo(cell.rx_reusableDisposeBag)
         }
         
         class RxCollectionViewCell: UICollectionViewCell {
         private (set) var rx_reusableDisposeBag = DisposeBag()
         override func prepareForReuse() {
         rx_reusableDisposeBag = DisposeBag()
         super.prepareForReuse()
         }
         }
         
         // Note that we invoked addDisposableTo with cell’s disposeBag, not the dataSource’s bag,
         // otherwise, you will get multiple events for just one button tap.
         */
    }
    
    func testNotification()
    {
        class Foo: UIViewController
        {
            override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
                //            _ = NotificationCenter.default.rx
                //                .notification(NSNotification.Name.UIResponder.keyboardDidShowNotification) // change
                //                .takeUntil(rx.methodInvoked(#selector(viewWillDisappear(_:)))) // automatically disposes when viewWillDisappear is invoked
                //                .subscribe{ notification in print(notification) }
            }
        }
    }
}
