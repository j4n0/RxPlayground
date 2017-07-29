//: Playground - noun: a place where people can play

import UIKit
import RxSwift

_ = Observable<Void>.empty()
    .subscribe(onNext: { element in
        print(element) // never executes
    }, onCompleted: {
        print("Completed")
    })

