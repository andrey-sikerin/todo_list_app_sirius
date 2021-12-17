//
//  ToDoCell.swift
//  TODO_list_app
//
//  Created by danuhaha on 11.12.2021.
//

import UIKit
import RxCocoa
import RxSwift

class ToDoCell: UITableViewCell {

    private lazy var viewModel = ToDoCellViewModel(text: "", deadline: nil, completeButtonImage: nil, priorityImage: nil)

    static let identifier = "toDoCellIdentifier"

    public func configureCell(todoItem: TodoItem) {
        taskLabel.text = todoItem.text
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .short

        var deadlineViewModel: ToDoCellViewModel.DeadlineViewModel? = nil
        if let date = todoItem.deadline {
            let stringDate = dateFormatter.string(from: date)
            let icon = UIImage(systemName: "calendar")!
            deadlineViewModel = ToDoCellViewModel.DeadlineViewModel(icon: icon, date: stringDate)
            deadlineLabel.text = stringDate
            deadlineLabel.font = UIFont.systemFont(ofSize: 15)
            deadlineLabel.textColor = Color.labelTertiary
            calendarImageView.image = icon.withTintColor(Color.labelTertiary, renderingMode: .alwaysTemplate)
            calendarImageView.tintColor = Color.labelTertiary
            calendarImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
            calendarImageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        }

        var imageName: String = ""
        var spacing: CGFloat = 0
        switch todoItem.priority {
        case .high:
            imageName = "highPriorityIcon"
            spacing = 5
        case .normal:
            imageName = ""
            spacing = 0
        case .low:
            imageName = "lowPriorityIcon"
            spacing = 5
        }
        priorityImageView.image = UIImage(named: imageName)
        taskStackView.spacing = spacing
        let priorityImage = ToDoCellViewModel.PriorityImageViewModel(icon: UIImage(named: imageName), spacing: 5)

        viewModel = ToDoCellViewModel(text: todoItem.text, deadline: deadlineViewModel,
                completeButtonImage: UIImage(named: "notDoneState")!, priorityImage: priorityImage)
    }

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 12
        return stackView
    }()

    var disposeBag = DisposeBag()

    private lazy var completeButton: UIButton = {
        let button = UIButton()
// TODO copy to configure function
        let image: () = viewModel.completeButtonImage.subscribe(onNext: {
                    [weak self] image in
                    button.setImage(image, for: .normal)
                }, onError: nil, onCompleted: nil, onDisposed: nil)
                .disposed(by: disposeBag)
        button.rx.tap.subscribe(onNext: { [weak self] in
                    self?.viewModel.buttonPressed()
                })
                .disposed(by: disposeBag)


        return button
    }()

    private var taskCompleted = false

    private let rightArrowImageView = UIImageView(image: UIImage(named: "rightArrowIcon"))

    private lazy var cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var taskStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill

        if viewModel.priorityImage?.spacing != nil {
            stackView.spacing = viewModel.priorityImage!.spacing
        } else {
            stackView.spacing = 0
        }
        return stackView
    }()

    private lazy var deadlineStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 2.5
        return stackView
    }()

    private lazy var priorityImageView: UIImageView = {
        guard let image = viewModel.priorityImage?.icon
                else {
            return UIImageView(image: nil)
        }

        let imageView = UIImageView(image: image)
        imageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        imageView.clipsToBounds = false
        return imageView
    }()

    private lazy var taskLabelText = viewModel.taskText

    private lazy var taskLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()

    private lazy var calendarImageView: UIImageView = {
        guard let image = viewModel.deadline?.icon
                else {
            return UIImageView(image: nil)

}
        let imageView = UIImageView(image: image.withTintColor(Color.labelTertiary))
        imageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 13).isActive = true
        imageView.tintColor = Color.labelTertiary
        return imageView
    }()

    private lazy var deadlineLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = Color.labelTertiary
        guard let text = viewModel.deadline?.date
                else {
            return UILabel()
}
        label.text = text

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(stackView)
        stackView.frame = CGRect(
                x: 16,
                y: 0,
                width: contentView.bounds.width,
                height: 56
        )
        stackView.addArrangedSubview(completeButton)
        stackView.addArrangedSubview(cellStackView)
        stackView.addArrangedSubview(rightArrowImageView)
        cellStackView.addArrangedSubview(taskStackView)
        cellStackView.addArrangedSubview(deadlineStackView)
        taskStackView.addArrangedSubview(priorityImageView)
        taskStackView.addArrangedSubview(taskLabel)
        taskLabel.text = taskLabelText
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

}
