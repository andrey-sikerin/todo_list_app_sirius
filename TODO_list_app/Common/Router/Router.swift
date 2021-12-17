//
//  Router.swift
//  TODO_list_app
//
//  Created by danuhaha on 15.12.2021.
//

import Foundation
import UIKit

typealias PopAction = () -> Void
typealias PushAction = (UIViewController) -> Void
typealias DismissAction = (UIViewController) -> Void
typealias PresentAction = (UIViewController) -> Void
typealias TransitionAction = (TransitionMode, UIViewController, TodoItem) -> Void
typealias DeleteAction =  (String) -> Void
typealias VoidAction = () -> Void

struct RootRouter {
    var pushAction: PushAction
    var popAction: PopAction
    var presentAction: PresentAction
    var dismissAction: DismissAction
}

enum TransitionMode {
    case push
    case present
}
