//
//  LabelTableViewCell.swift
//  AlefTestProblem
//
//  Created by Ruslan Abbasov on 26.10.2022.
//

import UIKit

class LabelTableViewCell: UITableViewCell {

    @IBOutlet private weak var label: UILabel!

    public func chageLabelText(text: String) {
        label.text = text
    }

}
