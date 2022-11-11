//
//  TextFieldHalfCell.swift
//  AlefTestProblem
//
//  Created by Ruslan Abbasov on 02.11.2022.
//

import UIKit

class TextFieldHalfTableViewCell: UITableViewCell {

    public var isSubscribedFlag = false
    public var prototype: TextfieldHalfCellPrototype?

    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var textfield: UITextField!
    @IBOutlet private weak var borderView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.lightGray.cgColor
        borderView.layer.cornerRadius = borderView.frame.size.height / 10
    }

    override func prepareForReuse() {
        super.prepareForReuse()

//        textfield.text = prototype?.text
        prototype?.text = textfield.text ?? ""
    }

    public func clearTextField() {
        textfield.text = ""
    }

    public func changeTextfield(text: String) {
        textfield.text = text
    }

    public func changeSubtitleLabel(text: String) {
        subtitleLabel.text = text
    }

}
