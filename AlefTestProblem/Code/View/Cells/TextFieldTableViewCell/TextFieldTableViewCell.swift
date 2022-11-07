//
//  TextFieldTableViewCell.swift
//  AlefTestProblem
//
//  Created by Ruslan Abbasov on 26.10.2022.
//

import UIKit
import Combine

class TextFieldTableViewCell: UITableViewCell {
    public var isSubscribedFlag = false
    private var subscriptions = Set<AnyCancellable>()

    @IBOutlet private weak var textfield: UITextField!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var borderView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.lightGray.cgColor
        borderView.layer.cornerRadius = borderView.frame.size.height / 10
    }

    public func changeSubtitleLabel(text: String) {
        subtitleLabel.text = text
    }

    public func clearTextfield() {
        textfield.text = ""
    }

}
