import UIKit


class PriorityStackViewContainer: UIView {
    private let priorityStackView = UIStackView()
    private let itemBorderRadius: CGFloat = AppStyles.borderRadius


    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(priorityStackView)
        setPriorityStackView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setPriorityStackView() {
        priorityStackView.backgroundColor = .orange
        priorityStackView.translatesAutoresizingMaskIntoConstraints = false
        priorityStackView.layer.cornerRadius = itemBorderRadius
        priorityStackView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        priorityStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        priorityStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        priorityStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true

    }
}