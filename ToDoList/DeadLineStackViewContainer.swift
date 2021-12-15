import UIKit

class DeadLineStackViewContainer: UIView {
    private let deadLineStackView = UIStackView()
    private let itemBorderRadius = AppStyles.borderRadius


    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(deadLineStackView)
        setDeadLineStackView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setDeadLineStackView() {
        deadLineStackView.backgroundColor = .yellow
        deadLineStackView.translatesAutoresizingMaskIntoConstraints = false
        deadLineStackView.layer.cornerRadius = itemBorderRadius
        deadLineStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        deadLineStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        deadLineStackView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        deadLineStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
}