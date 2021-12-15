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
        let icon: UIImage
        let spacing: CGFloat
    }

    let priorityImage: PriorityImageViewModel?

    let taskText: String

    struct DeadlineViewModel {
        let icon: UIImage
        let date: String
    }

    let deadline: DeadlineViewModel?

    func buttonPressed() {
        print("button pressed")
        
    }

    init() {
        completeButtonImage = Observable.just(UIImage(named: "notDoneState")!)
        priorityImage = PriorityImageViewModel(
            icon: UIImage(named: "lowPriorityIcon")!,
            spacing: 5)
        taskText = "Text"
        deadline = nil
    }




}
