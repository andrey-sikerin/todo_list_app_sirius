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

    private var viewModel: ToDoCellViewModel?

    static let identifier = "toDoCellIdentifier"

    public func configureCell(viewModel: ToDoCellViewModel) {
        compositeDisposableBag.dispose()
        self.viewModel = viewModel

        if let deadline = viewModel.deadline {
            deadlineLabel.isHidden = false
            calendarImageView.isHidden = false
            deadlineLabel.text = deadline.date
            calendarImageView.image = deadline.icon
        } else {
            deadlineLabel.isHidden = true
            calendarImageView.isHidden = true
        }


        if let _ = viewModel.priorityImage {
            priorityImageView.image = viewModel.priorityImage?.icon
            taskStackView.spacing = viewModel.priorityImage?.spacing ?? 0
        }

        completeButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.viewModel?.buttonPressed()
        })
            .disposed(by: disposeBag)

        viewModel.componentsObservable.subscribe(onNext: { [weak self] components in
            self?.taskLabel.attributedText = components.attributedText
            self?.completeButton.setImage(components.buttonImage, for: .normal)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
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
    var compositeDisposableBag = CompositeDisposable()

    private lazy var completeButton: UIButton = {
        let button = UIButton()
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
        let imageView = UIImageView()
        imageView.clipsToBounds = false
        return imageView
    }()

    private lazy var taskLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()

    private lazy var calendarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 13).isActive = true
        imageView.tintColor = Color.labelTertiary
        return imageView
    }()

    private lazy var deadlineLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = Color.labelTertiary
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
