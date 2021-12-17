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
    var text: BehaviorSubject<String>
    var showingDatePicker: BehaviorSubject<Bool>
    var showPlaceholder: BehaviorSubject<Bool>
    var priorityContainer: PriorityContainer
    var deadlineContainer: DeadlineContainer
    private var _showingDatePicker: Bool
    private var selectedDate: Date?
    
    struct PriorityContainer {
        var segmentedIndex: BehaviorSubject<Int>
        
        init(priority: TodoItem.Priority) {
            let value: Int
            switch priority {
            case .low: value = 0
            case .normal: value = 1
            case .high: value = 2
            }
            self.segmentedIndex = BehaviorSubject(value: value)
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
    var transitionAction: TransitionAction
    
    init(item: TodoItem, transitionToTaskList: @escaping TransitionAction) {
        self.transitionAction = transitionToTaskList
        self.text = BehaviorSubject(value: item.text)
        
        self.selectedDate = item.deadline
        
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
        
        deadlineContainer._isSwitcherOn = deadlineContainer._isSwitcherOn || _showingDatePicker
        deadlineContainer.isSwitcherOn.on(.next(deadlineContainer._isSwitcherOn))
        
        selectNewDate(date)
    }
    
    func switcherTapped(isOn: Bool, date: Date) {
        showingDatePicker.on(.next(!isOn))
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
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeZone = .none
        return formatter
    }()
}

