//
//  AddNewTaskCell.swift
//  TODO_list_app
//
//  Created by Artem Goldenberg on 13.12.2021.
//

import UIKit

class AddNewTaskCell: UITableViewCell {

    private let labelStyle: LabelStyle = .defaultStyle
    private let plusIconLayoutStyle: PlusIconLayoutStyle = .defaultStyle
    static let defaultReuseIdentifier = "AddNewTaskCellReuseIdentifier"

    public struct PlusIconLayoutStyle {
        let rightOffset: CGFloat
        let topOffset: CGFloat
        let width: CGFloat
        let height: CGFloat
    }

    public struct LabelStyle {
        let plusButtonRightOffset: CGFloat
        let topOffset: CGFloat
        let width: CGFloat
        let height: CGFloat
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
            x: plusIconLayoutStyle.rightOffset + plusIconLayoutStyle.width + labelStyle.plusButtonRightOffset,
            y: plusIconLayoutStyle.topOffset,
            width: labelStyle.width,
            height: labelStyle.height)
        return label
    }()
    
    private lazy var plusIcon: UIImageView = {
        let iconView = UIImageView(image: UIImage(named: "addNewTaskCellButton"))
        iconView.contentMode = .scaleAspectFit
        iconView.frame = CGRect(
            x: plusIconLayoutStyle.rightOffset,
            y: plusIconLayoutStyle.topOffset,
            width: plusIconLayoutStyle.width,
            height: plusIconLayoutStyle.height)
        return iconView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(plusIcon)
        contentView.addSubview(label)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate extension AddNewTaskCell.PlusIconLayoutStyle {
    static let defaultStyle = Self.init (
        rightOffset: 16,
        topOffset: 16,
        width: 24,
        height: 24)
}

fileprivate extension AddNewTaskCell.LabelStyle {
    static let defaultStyle = Self.init (
        plusButtonRightOffset: 12,
        topOffset: 17,
        width: 51,
        height: 22
    )
}
