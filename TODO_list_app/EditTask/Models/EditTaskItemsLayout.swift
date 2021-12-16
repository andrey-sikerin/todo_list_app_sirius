//
// Created by user on 16.12.2021.
//

import Foundation
import UIKit

class EditTaskItemsLayout {



    let buttonFrame : CGRect
    let stackViewFrame : CGRect
    let contentSizeHeight : CGFloat
    let contentOffset : CGPoint

    init(
            contentSize: CGSize,
            stackViewHeight : CGFloat,
            buttonHeight: CGFloat,
            textViewHeight: CGFloat,
            datePickerHeight: CGFloat,
            itemsMargin: CGFloat,
            boundsMinX: CGFloat,
            boundsHeight : CGFloat,
            contentInsetBottom : CGFloat

    ) {

        stackViewFrame = CGRect(
                origin: CGPoint(x: 0, y:textViewHeight + itemsMargin),
                size: CGSize(width: contentSize.width, height: stackViewHeight + datePickerHeight)
        )

        buttonFrame = CGRect(
                origin: CGPoint(x: 0, y: stackViewFrame.maxY + itemsMargin),
                size: CGSize(width: contentSize.width, height: buttonHeight)
        )
        contentSizeHeight = stackViewHeight + textViewHeight + 3*itemsMargin

        contentOffset = CGPoint(x: boundsMinX, y: contentSizeHeight - boundsHeight + contentInsetBottom)
    }

}