//
//  ToDoCellViewModel.swift
//  TODO_list_app
//
//  Created by danuhaha on 13.12.2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ToDoCellViewModel {
    var completeButtonImage: Observable<UIImage>

    struct PriorityImageViewModel {
        let icon: UIImage?
        let spacing: CGFloat
    }

    let priorityImage: PriorityImageViewModel?

    let taskText: String

    struct DeadlineViewModel {
        let icon: UIImage?
        let date: String
    }

    let deadline: DeadlineViewModel?

    func buttonPressed() {
        print("button pressed")
    }

    private let editAction: TransitionAction
    private let todoItem: TodoItem

    init(todoItem: TodoItem, editAction: @escaping TransitionAction) {
        self.todoItem = todoItem
        self.editAction = editAction
        if let date = todoItem.deadline {
            deadline = DeadlineViewModel(
                icon: UIImage(systemName: "calendar")!,
                date: DateFormatter.todoItemViewModelFormatter.string(from: date)
            )
        } else {
            self.deadline = nil
        }

        switch todoItem.priority {
        case .high:
            priorityImage = PriorityImageViewModel(icon: UIImage(named: "highPriorityIcon"), spacing: 5)
        case .normal:
            priorityImage = PriorityImageViewModel(icon: nil, spacing: 0)
        case .low:
            priorityImage = PriorityImageViewModel(icon: UIImage(named: "lowPriorityIcon"), spacing: 5)
        }

        taskText = todoItem.text

        if todoItem.done {
            completeButtonImage = Observable.just(UIImage(named: "doneState")!)
        } else {
            completeButtonImage = Observable.just(UIImage(named: "notDoneState")!)
        }
    }

    func select(mode: TransitionMode, viewController: UIViewController) {
      editAction(mode, viewController, todoItem)
    }
}

fileprivate extension DateFormatter {
    static let todoItemViewModelFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        return formatter
    }()
}

