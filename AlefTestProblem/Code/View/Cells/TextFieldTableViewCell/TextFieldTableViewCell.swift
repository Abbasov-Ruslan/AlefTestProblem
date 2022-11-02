//
//  TextFieldTableViewCell.swift
//  AlefTestProblem
//
//  Created by Ruslan Abbasov on 26.10.2022.
//

import UIKit
import Combine

class TextFieldTableViewCell: UITableViewCell {

    public var clearTextFieldSubject = PassthroughSubject<Void, Never>()
    private var subscriptions = Set<AnyCancellable>()

    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var borderView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.lightGray.cgColor
        borderView.layer.cornerRadius = borderView.frame.size.height / 10

        clearTextFieldSubject.sink { [weak self] _ in
            self?.textfield.text = ""
        }.store(in: &subscriptions)
    }
    
}
