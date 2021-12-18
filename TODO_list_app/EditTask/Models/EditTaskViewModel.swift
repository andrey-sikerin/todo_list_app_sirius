//
//  EditTaskViewModel.swift
//  TODO_list_app
//
//  Created by Artem Goldenberg on 16.12.2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class EditTaskViewModel {
    let text: BehaviorSubject<String>
    let showingDatePicker: BehaviorSubject<Bool>
    let showPlaceholder: BehaviorSubject<Bool>
    let priorityContainer: PriorityContainer
    private let todoItem: TodoItem
    let deadlineContainer: DeadlineContainer
    private var _showingDatePicker: Bool
    private var selectedDate: Date?

    struct PriorityContainer {
        let segmentedIndex: BehaviorSubject<Int>

        init(priority: TodoItem.Priority) {
            let value: Int
            switch priority {
            case .low: value = 0
            case .normal: value = 1
            case .high: value = 2
            }
            self.segmentedIndex = BehaviorSubject(value: value)
        }

        var getPriority: TodoItem.Priority {
            let value = try! segmentedIndex.value()
            switch value {
            case 0: return .low
            case 1: return .normal
            case 2: return .high
            default: return .normal
            }
        }
    }

    struct DeadlineContainer {
        var secondaryLabelText: BehaviorSubject<String>
        var isSwitcherOn: BehaviorSubject<Bool>
        fileprivate var _isSwitcherOn: Bool

        init(secondaryLabelText: String, isSwitcherOn: Bool) {
            self._isSwitcherOn = isSwitcherOn

            self.isSwitcherOn = BehaviorSubject(value: isSwitcherOn)

            self.secondaryLabelText = BehaviorSubject(value: secondaryLabelText)
        }
    }

    typealias TransitionAction = () -> Void
    let transitionAction: TransitionAction
    private let deleteAction: DeleteAction
    private let updateAction: UpdateAction
    let isDeleteButtonDisabled: Bool

    init(
        item: TodoItem,
        transitionToTaskList: @escaping TransitionAction,
        deleteAction: @escaping DeleteAction,
        updateAction: @escaping UpdateAction,
        isDeleteButtonDisabled: Bool
    ) {
        self.transitionAction = transitionToTaskList
        self.isDeleteButtonDisabled = isDeleteButtonDisabled
        self.deleteAction = deleteAction
        self.updateAction = updateAction
        self.todoItem = item
        self.text = BehaviorSubject(value: item.text)
        self.selectedDate = item.deadlineDate

        let secondaryLabelText: String
        if let date = selectedDate {
            secondaryLabelText = dateFormatter.string(from: date)
        } else {
            secondaryLabelText = ""
        }
        let deadlineContainer = DeadlineContainer(
            secondaryLabelText: secondaryLabelText,
            isSwitcherOn: selectedDate != nil
        )

        self.priorityContainer = PriorityContainer(priority: item.priority)
        self.deadlineContainer = deadlineContainer
        self._showingDatePicker = false

        self.showingDatePicker = BehaviorSubject(value: _showingDatePicker)

        self.showPlaceholder = BehaviorSubject(value: item.text == "")
    }

    func toggleCalendar(with date: Date) {
        _showingDatePicker.toggle()

        showingDatePicker.on(.next(_showingDatePicker))

        let isSwitcherOn = deadlineContainer._isSwitcherOn || _showingDatePicker
        deadlineContainer.isSwitcherOn.on(.next(isSwitcherOn))

        selectNewDate(date)
    }

    func switcherTapped(isOn: Bool, date: Date) {
        showingDatePicker.on(.next(isOn))
        if isOn {
            selectNewDate(date)
        } else {
            selectNewDate(nil)
        }
    }

    func selectNewDate(_ date: Date?) {
        selectedDate = date
        if let date = date {
            deadlineContainer.secondaryLabelText.on(.next(dateFormatter.string(from: date)))
        } else {
            deadlineContainer.secondaryLabelText.on(.next(""))
        }
    }

    func delete() {
        deleteAction(todoItem.id)
    }

    func saveUpdateItem() {
        var updatedItem = todoItem
        updatedItem.text = try! text.value()
        updatedItem.updatedAt = NSDate().timeIntervalSince1970
        updatedItem.deadline = selectedDate?.timeIntervalSince1970
        updatedItem.isDirty = true
        updatedItem.priority = priorityContainer.getPriority
        updateAction(updatedItem)
        transitionAction()
    }

    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeZone = .none
        return formatter
    }()
}

