import UIKit
import RxSwift


class PriorityStackViewContainer: UIView {
    private let priorityStackView = UIStackView()
    private let labelImportance = UILabel()
    private let segmentControl = UISegmentedControl(
            items: ["",  NSLocalizedString("SegmentControlNoneText", comment: ""),  ""]
    )
    private let layoutStyles : LayoutStyles

    private var viewModel: EditTaskViewModel.PriorityContainer

    struct LayoutStyles{
        let itemCornerRadius: CGFloat
        let labelLeftPadding: CGFloat
        let segmentControlRightPadding: CGFloat
        let segmentControlHeight : CGFloat
        let segmentControlWidth : CGFloat
        init(itemCornerRadius : CGFloat, labelLeftPadding : CGFloat,
             segmentControlRightPadding : CGFloat, segmentControlHeight : CGFloat,
             segmentControlWidth : CGFloat){
            self.itemCornerRadius = itemCornerRadius
            self.labelLeftPadding = labelLeftPadding
            self.segmentControlRightPadding = segmentControlRightPadding
            self.segmentControlHeight = segmentControlHeight
            self.segmentControlWidth = segmentControlWidth
        }
    }

    override required init(frame : CGRect){
        fatalError("init(frame:) has not been implemented")
    }

    required init(viewModel: EditTaskViewModel.PriorityContainer, frame : CGRect, layout : LayoutStyles){
        layoutStyles = layout
        self.viewModel = viewModel
        super.init(frame: frame)
        addSubview(priorityStackView)
        setupPriorityStackView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setupPriorityStackView() {
        priorityStackView.axis = .horizontal
        priorityStackView.distribution = .equalCentering
        priorityStackView.alignment = .center
        priorityStackView.translatesAutoresizingMaskIntoConstraints = false
        priorityStackView.layer.cornerRadius = layoutStyles.itemCornerRadius
        priorityStackView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        priorityStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        priorityStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        priorityStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        priorityStackView.addArrangedSubview(labelImportance)
        priorityStackView.addArrangedSubview(segmentControl)
        setupLabelImportance()
        setupSegmentControl()
    }


    private func setupLabelImportance() {
        labelImportance.text = NSLocalizedString("LabelImportanceText", comment: "");
        labelImportance.leftAnchor.constraint(equalTo: priorityStackView.leftAnchor, constant: layoutStyles.labelLeftPadding).isActive = true
    }

    private let disposeBag = DisposeBag()
    private func setupSegmentControl() {
        viewModel.segmentedIndex.subscribe(onNext: { [weak self] index in
            self?.segmentControl.selectedSegmentIndex = index
        }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        segmentControl.heightAnchor.constraint(equalToConstant: layoutStyles.segmentControlHeight).isActive = true
        segmentControl.widthAnchor.constraint(equalToConstant: layoutStyles.segmentControlWidth).isActive = true
        segmentControl.rightAnchor.constraint(equalTo: rightAnchor,
                constant: layoutStyles.segmentControlRightPadding).isActive = true
        segmentControl.setImage(UIImage(named: "lowPriorityIcon"), forSegmentAt: 0)
        segmentControl.setImage(UIImage(named: "highPriorityIcon"), forSegmentAt: 2)
        segmentControl.addTarget(self, action: #selector(segmentControlValueChanged(_:)), for: .valueChanged)
    }

    @objc func segmentControlValueChanged(_ sender: UISegmentedControl) {
        viewModel.segmentedIndex.onNext(segmentControl.selectedSegmentIndex)
    }
}
