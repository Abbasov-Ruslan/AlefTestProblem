//
//  TextFieldHalfCell.swift
//  AlefTestProblem
//
//  Created by Ruslan Abbasov on 02.11.2022.
//

import UIKit

class TextFieldHalfTableViewCell: UITableViewCell {

    public var isSubscribedFlag = false

    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var textfield: UITextField!
    @IBOutlet private weak var borderView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.lightGray.cgColor
        borderView.layer.cornerRadius = borderView.frame.size.height / 10
    }

    public func clearTextField() {
        textfield.text = ""
    }

    public func changeSubtitleLabel(text: String) {
        subtitleLabel.text = text
    }

}
