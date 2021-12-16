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

    init(text: String = "default text", deadline: DeadlineViewModel?, completeButtonImage: UIImage?, priorityImage: PriorityImageViewModel?) {
        if let img = completeButtonImage {
            self.completeButtonImage = Observable.just(img)
        } else {
            self.completeButtonImage = Observable.just(UIImage(named: "notDoneState")!)
        }
        self.priorityImage = priorityImage
        taskText = text
        self.deadline = deadline
    }
}
