//
//  HeaderView.swift
//  TODO_list_app
//
//  Created by danuhaha on 15.12.2021.
//

import UIKit

class HeaderView: UIView {

    private var labelText: String?
    private var buttonText: String?
    private var doneAmount: Int?

    private let doneAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        label.font = UIFont.systemFont(ofSize: 15)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let showDoneButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(red: 0, green: 0.478, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.heightAnchor.constraint(equalToConstant: 32).isActive = true

        doneAmountLabel.text = "\(labelText) - \(doneAmount)"
        showDoneButton.setTitle(buttonText, for: .normal)

        self.addSubview(doneAmountLabel)
        self.addSubview(showDoneButton)

        showDoneButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        showDoneButton.topAnchor.constraint(equalTo: self.topAnchor, constant: -6).isActive = true
        doneAmountLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func updateDoneAmount(_ doneAmount: Int) {
        self.doneAmount = doneAmount
        doneAmountLabel.text = "\(labelText) - \(doneAmount)"
    }
    
    func updateHeaderButton(buttonText: String) {
        showDoneButton.setTitle(buttonText, for: .normal)
    }
    
    func configureHeader(doneAmount: Int, labelText: String, showDoneButtonText: String, hideDoneButtonText: String ) {
        doneAmountLabel.text = "\(labelText) - \(doneAmount)"
        showDoneButton.setTitle(showDoneButtonText, for: .normal)
        
    }

}
