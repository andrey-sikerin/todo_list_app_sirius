//
//  HeaderView.swift
//  TODO_list_app
//
//  Created by danuhaha on 15.12.2021.
//

import UIKit
import RxSwift

class HeaderView: UIView {
    private let viewModel : HeaderViewModel

    private let doneAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.labelTertiary
        label.font = UIFont.systemFont(ofSize: 15)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let showDoneButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Color.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onButtonPress), for: .touchUpInside)
        return button
    }()

  
  private let disposeBag = DisposeBag()

  required init(viewModel: HeaderViewModel) {
    self.viewModel = viewModel

    super.init(frame: .zero)

    self.heightAnchor.constraint(equalToConstant: 32).isActive = true

    self.addSubview(doneAmountLabel)
    self.addSubview(showDoneButton)

    showDoneButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
    showDoneButton.topAnchor.constraint(equalTo: self.topAnchor, constant: -6).isActive = true
    doneAmountLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true

    viewModel.observableButtonText.subscribe(
        onNext: { [weak self] text in
          self?.showDoneButton.setTitle(text, for: .normal)
        },
        onError: nil,
        onCompleted: nil,
        onDisposed: nil
    ).disposed(by: disposeBag)


    viewModel.observableDoneAmount.subscribe(
        onNext: { [weak self] text in
          self?.doneAmountLabel.text = text
        },
        onError: nil,
        onCompleted: nil,
        onDisposed: nil
    ).disposed(by: disposeBag)
  }

    override init(frame: CGRect) {
      fatalError("init(frame:) has not been implemented")
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
  
    @objc func onButtonPress() {
      viewModel.doneButtonPressed()
    }
}
