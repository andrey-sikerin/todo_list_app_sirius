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
    private let componentsSubject: BehaviorSubject<UIComponents>
    var componentsObservable: Observable<UIComponents> { componentsSubject }

    struct UIComponents {
        var swipeImage: UIImage
        var swipeColor: UIColor
        var buttonImage: UIImage
        var attributedText: NSAttributedString

        init(for item: TodoItem) {
            if item.done {
                swipeImage = UIImage(systemName: SwipeIconsStyle.undoneIconName)!.withTintColor(.white, renderingMode: .alwaysOriginal)
                swipeColor = SwipeIconsStyle.backgroundUndone
                buttonImage = UIImage(named: "doneState")!
                attributedText = NSAttributedString(string: item.text, attributes: [
                    .foregroundColor : TextColor.secondary,
                    .strikethroughStyle : 2,
                    .strikethroughColor : TextColor.secondary
                ])
            } else {
                swipeImage = UIImage(named: SwipeIconsStyle.doneIconName)!
                swipeColor = SwipeIconsStyle.backgroundDone
                buttonImage =  UIImage(named: item.priority != .high ? "notDoneState" : "highPriorityState")!
                attributedText = NSAttributedString(string: item.text, attributes: [
                    .foregroundColor : TextColor.primary
                ])
            }
        }
    }

    private struct SwipeIconsStyle {
        static let doneIconName = "doneIcon"
        static let undoneIconName = "clear"
        static let backgroundDone = Color.green
        static let backgroundUndone = Color.red
    }

    private struct TextColor {
        static let primary = Color.labelPrimary
        static let secondary = Color.labelTertiary
    }

    struct PriorityImageViewModel {
        let icon: UIImage?
        let spacing: CGFloat
    }

    let priorityImage: PriorityImageViewModel?

//    let taskText: String

    struct DeadlineViewModel {
        let icon: UIImage?
        let date: String
    }

    let deadline: DeadlineViewModel?

    func buttonPressed() {
        var item = todoItem
        item.isDirty = true
        item.updatedAt = Date().timeIntervalSince1970
        item.done.toggle()
        updateAction(item)

        componentsSubject.on(.next(UIComponents(for: todoItem)))
    }

    private let editAction: TransitionAction
    private let deleteAction: DeleteAction
    private let todoItem: TodoItem

    private let updateAction: UpdateAction

    init(todoItem: TodoItem, updateAction: @escaping UpdateAction, editAction: @escaping TransitionAction,
        deleteAction: @escaping DeleteAction) {
        self.updateAction = updateAction
        self.todoItem = todoItem
        self.editAction = editAction
        self.deleteAction = deleteAction
        if let date = todoItem.deadlineDate {
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

//        taskText = todoItem.text
        
        componentsSubject = BehaviorSubject(value: UIComponents(for: todoItem))
    }

    func select(mode: TransitionMode, viewController: UIViewController) {
        var updateItem = todoItem
        updateItem.updatedAt = Date().timeIntervalSince1970
        editAction(mode, viewController, updateItem)
    }

    func delete() {
        deleteAction(todoItem.id)
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

