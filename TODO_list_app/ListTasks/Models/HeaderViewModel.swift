//
// Created by user on 17.12.2021.
//

import Foundation
import RxSwift
import RxCocoa

class HeaderViewModel {

    private let subjectDoneAmount: PublishSubject<Int>
    private let subjectButtonText: PublishSubject<String>
    var observableDoneAmount : Observable<Int>  {
        subjectDoneAmount
    }
    var observableButtonText: Observable<String> {
        subjectButtonText
    }
    init() {
        subjectDoneAmount = PublishSubject()
        subjectDoneAmount.onNext(0)
        subjectButtonText = PublishSubject()
        subjectButtonText.onNext(NSLocalizedString("Show", comment: ""))
    }

}