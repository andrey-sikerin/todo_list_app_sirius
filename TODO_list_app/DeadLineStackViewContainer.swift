import UIKit
import RxSwift

class DeadLineStackViewContainer: UIView {
    typealias ToggleCalendar = () -> Void
    typealias OnSwitcherTapped = (Bool) -> Void
    
    private let stackView = UIStackView()
    private let itemBorderRadius = AppStyles.borderRadius
    private let labelsStack = UIStackView()
    private let primaryLabel = UILabel()
    let switcher = UISwitch()
    let secondaryLabel = UILabel()
    
    private let layoutStyles: EditTaskViewController.LayoutStyles = .defaultStyle
    private let strings = EditTaskViewController.Strings(
        leftNavigationBarText: NSLocalizedString("Cancel", comment: ""),
        rightNavigationBarText: NSLocalizedString("Save", comment: ""),
        titleNavigationBarText: NSLocalizedString("Task", comment: ""),
        textViewPlaceholder: NSLocalizedString("TaskDescriptionPlaceholder", comment: ""),
        buttonText: NSLocalizedString("Delete", comment: ""),
        doBeforeText: NSLocalizedString("Make up", comment: "")
    )
    
    private var viewModel: EditTaskViewModel.DeadlineContainer
    
    private var switcherTapped: OnSwitcherTapped
    private var toggleCalendar: ToggleCalendar
    required init(
        viewModel: EditTaskViewModel.DeadlineContainer,
        switcherTapped: @escaping OnSwitcherTapped,
        toggleCalendar: @escaping ToggleCalendar)
    {
        self.viewModel = viewModel
        self.switcherTapped = switcherTapped
        self.toggleCalendar = toggleCalendar
        super.init(frame: .zero)
        addSubview(stackView)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapTriggered))
        recognizer.cancelsTouchesInView = true 
        addGestureRecognizer(recognizer)
        self.setupDeadLineStackView()
        self.setupPrimaryLabel()
        self.setupSecondaryLabel()
        self.setupLabelsStack()
        self.setupSwitcher()
    }

    required override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapTriggered(sender: UITapGestureRecognizer) {
        toggleCalendar()
    }
    
    @objc func switcherTap(sender: UISwitch) {
        switcherTapped(sender.isOn)
    }
    
    private var disposeBag = DisposeBag()
    
    private func setupSwitcher() {
        viewModel.isSwitcherOn.subscribe(onNext: { [weak self] isOn in
            self?.switcher.isOn = isOn
        }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        switcher.preferredStyle = .sliding
        switcher.addTarget(self, action: #selector(switcherTap), for: .allTouchEvents)
    }
    
    private func setupLabelsStack() {
        labelsStack.axis = .vertical
        labelsStack.alignment = .leading
        labelsStack.spacing = 0
        labelsStack.distribution = .fillProportionally
        labelsStack.addArrangedSubview(primaryLabel)
        labelsStack.addArrangedSubview(secondaryLabel)
    }
    
    private func setupPrimaryLabel() {
        primaryLabel.text = strings.doBeforeText
        primaryLabel.font = .systemFont(ofSize: layoutStyles.primaryLabelFontSize)
    }
    
    private func setupSecondaryLabel() {
        viewModel.secondaryLabelText.subscribe(onNext: { [weak self] text in
            self?.secondaryLabel.text = text
        }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        secondaryLabel.font = .boldSystemFont(ofSize: layoutStyles.secondaryLabelFontSize)
        secondaryLabel.textColor = .systemBlue
    }

    private func setupDeadLineStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.addArrangedSubview(labelsStack)
        stackView.addArrangedSubview(switcher)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.addArrangedSubview(labelsStack)
        stackView.addArrangedSubview(switcher)
        stackView.layer.cornerRadius = layoutStyles.itemsBorderRadius
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: layoutStyles.labelsLeadingOffset).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -layoutStyles.switcherTrailingOffset).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true 
    }
}
