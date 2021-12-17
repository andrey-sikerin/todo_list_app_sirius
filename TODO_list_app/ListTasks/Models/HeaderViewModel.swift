//
// Created by user on 17.12.2021.
//

import Foundation
import RxSwift
import RxCocoa

class HeaderViewModel {
    struct Strings {
      let doneText: String
      let hideText: String
      let showText: String
    }
    enum Mode {
      case show
      case hide
    }
    let observableDoneAmount : Observable<String>
    let observableButtonText: Observable<String>

    private let todoItemsObservable: Observable<[TodoItem]>
    private let mode : BehaviorSubject<Mode>
    init(
      todoItemsObservable: Observable<[TodoItem]>,
      strings: Strings,
      modeSubject: BehaviorSubject<Mode>
    ) {
        self.todoItemsObservable = todoItemsObservable
        self.mode = modeSubject
        observableDoneAmount = todoItemsObservable.map { items in
          return "\(strings.doneText) - \(items.filter({ $0.done }).count)"
        }

      observableButtonText = mode.map { mode in
          switch mode {
          case .show:
            return strings.showText
          case .hide:
            return strings.hideText
          }
      }
    }

    func doneButtonPressed() {
      let value = try! mode.value()
      mode.onNext(value == .hide ? .show : .hide)
    }
}
