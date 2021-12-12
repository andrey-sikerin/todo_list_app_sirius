//
//  AddNewTaskCell.swift
//  TODO_list_app
//
//  Created by Artem Goldenberg on 13.12.2021.
//

import UIKit

class AddNewTaskCell: UITableViewCell {
    
    private struct PlusIcon {
        static let rightOffset: CGFloat = 16
        static let topOffset: CGFloat = 16
        static let width: CGFloat = 24
        static let height: CGFloat = 24
    }
    
    private struct Label {
        static let plusButtonRightOffset: CGFloat = 12
        static let topOffset: CGFloat = 17
        static let width: CGFloat = 51
        static let height: CGFloat = 22
    }
    
    private struct Cell {
        static let width: CGFloat = 375
        static let height: CGFloat = 56
    }
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Hовое"
        label.textColor = UIColor(
            red: 0,
            green: 0.478,
            blue: 1,
            alpha: 1)
        label.font = UIFont(name: "SFProText-Regular", size: 17)
        label.frame = CGRect(
            x: PlusIcon.rightOffset + PlusIcon.width + Label.plusButtonRightOffset,
            y: PlusIcon.topOffset,
            width: Label.width,
            height: Label.height)
        return label
    }()
    
    private lazy var plusIcon: UIImageView = {
        let icon = UIImage(named: "addNewTaskCellButton")
        let iconView = UIImageView(image: icon)
        iconView.contentMode = .scaleAspectFit
        iconView.frame = CGRect(
            x: PlusIcon.rightOffset,
            y: PlusIcon.topOffset,
            width: PlusIcon.width,
            height: PlusIcon.height)
        return iconView
    }()
    
    func configure() {
        contentView.frame = CGRect(
            x: 0,
            y: 0,
            width: Cell.width,
            height: Cell.height)
        contentView.addSubview(plusIcon)
        contentView.addSubview(label)
    }
}
