//
//  ToDoCell.swift
//  TODO_list_app
//
//  Created by danuhaha on 11.12.2021.
//

import UIKit

class ToDoCell: UITableViewCell {

    static let identifier = "toDoCellIdentifier"

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 12
        return stackView
    }()

    private let completeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "notDoneState"), for: .normal)
        return button
    }()

    private let rightArrowImageView = UIImageView(image: UIImage(named: "rightArrowIcon"))

    private let cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()

    private let taskStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()

    private let deadlineStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 3.5
        return stackView
    }()

    private let priorityImageView: UIImageView = {
        let image = UIImage(named: "lowPriorityIcon")
        let imageView = UIImageView(image: image)
        imageView.clipsToBounds = false
        imageView.frame.size = CGSize(width: 5, height: 5)
        return imageView
    }()

    private let taskLabel: UILabel = { 
        let label = UILabel()
        label.text = "Text"
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()

    private let calendarImageView: UIImageView = {
        let image = UIImage(systemName: "calendar")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        return imageView
    }()

    private let deadlineLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        label.text = "12.12.2012"
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(stackView)
        stackView.frame = CGRect(x: 16, y: 0, width: contentView.bounds.width, height: 56)
        stackView.addArrangedSubview(completeButton)
        stackView.addArrangedSubview(cellStackView)
        stackView.addArrangedSubview(rightArrowImageView)
        cellStackView.addArrangedSubview(taskStackView)
        cellStackView.addArrangedSubview(deadlineStackView)
        taskStackView.addArrangedSubview(priorityImageView)
        taskStackView.addArrangedSubview(taskLabel)
        deadlineStackView.addArrangedSubview(calendarImageView)
        deadlineStackView.addArrangedSubview(deadlineLabel)
        contentView.clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func prepareForReuse() {
        deadlineLabel.text = nil
        calendarImageView.image = nil
        taskLabel.text = nil
        priorityImageView.image = nil
        completeButton.imageView?.image = nil
    }

    public func configure() {
        
    }

}
