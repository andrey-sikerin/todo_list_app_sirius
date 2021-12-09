//
//  ViewController.swift
//  TODO_list_app
//
//  Created by user on 08.12.2021.
//

import UIKit
import RxSwift
import PromiseKit

class ViewController: UIViewController {
    let helloSequence = Observable.of("Hello Rx")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("loaded")
        helloSequence.subscribe { event in
          print(event)
        }
    }


}

