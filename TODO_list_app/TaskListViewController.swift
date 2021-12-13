//
//  TaskListViewController.swift
//  TODO_list_app
//
//  Created by Artem Goldenberg on 11.12.2021.
//

import Foundation
import UIKit

class TaskListViewController: UIViewController {

    private struct PlusButton {
        static let dimension: CGFloat = 54
        static let size = CGSize(width: dimension, height: dimension)
        static let bottomOffset: CGFloat = 56
        static let shadowRadius: CGFloat = 5
        static let shadowOpacity: Float = 0.1
        private static let shadowOffsetX: CGFloat = 0
        private static let shadowOffsetY: CGFloat = 14
        static let shadowOffsetSize = CGSize(width: shadowOffsetX, height: shadowOffsetY)
    }

    struct Strings {
        let titleNavigationBarText: String
    }

    private let strings: Strings

    init(strings: Strings) {
        self.strings = strings
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private lazy var taskTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        return tableView
    }()

    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "plusButton"), for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = PlusButton.shadowRadius
        button.layer.shadowOpacity = PlusButton.shadowOpacity
        button.layer.shadowOffset = PlusButton.shadowOffsetSize
        button.addTarget(self, action: #selector(plusButtonTriggered), for: .touchUpInside)
        return button
    }()

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        taskTableView.frame = view.bounds
        plusButton.frame = CGRect(
                origin: CGPoint(x: view.bounds.midX - PlusButton.dimension / 2,
                        y: view.bounds.maxY - (PlusButton.bottomOffset + PlusButton.dimension)),
                size: PlusButton.size)

        taskTableView.frame = view.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        title = strings.titleNavigationBarText
        setUpTableView()
        view.addSubview(plusButton)
    }

    func setUpTableView() {
        taskTableView.autoresizingMask = []
        taskTableView.delegate = self
        taskTableView.dataSource = self
        view.addSubview(taskTableView)
    }

    @objc func plusButtonTriggered(sender: Any) {
        print("Button Pressed")
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)!
        cell.backgroundColor = .blue
        return cell
    }
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "TasksList"
    }
}

fileprivate let reuseIdentifier = "test"
