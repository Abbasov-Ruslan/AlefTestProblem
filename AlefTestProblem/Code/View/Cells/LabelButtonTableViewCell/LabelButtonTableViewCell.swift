//
//  LabelButtonTableViewCell.swift
//  AlefTestProblem
//
//  Created by Ruslan Abbasov on 31.10.2022.
//

import UIKit
import Combine

class LabelButtonTableViewCell: UITableViewCell {

    let pressSubject = PassthroughSubject<Void, Never>()

    @IBOutlet private weak var addButton: UIButton!

    @IBAction private func buttonPress(_ sender: Any) {
        pressSubject.send()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        addButton.layer.borderColor = UIColor.systemBlue.cgColor

        addButton.layer.borderWidth  = 2.0
        addButton.layer.cornerRadius =  addButton.frame.size.height / 2
    }

    public func hideButton() {
        addButton.isHidden = true
    }

    public func showButton() {
        addButton.isHidden = false
    }
    
}
