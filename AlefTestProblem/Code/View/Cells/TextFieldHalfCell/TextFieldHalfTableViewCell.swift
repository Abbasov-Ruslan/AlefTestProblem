//
//  TextFieldHalfCell.swift
//  AlefTestProblem
//
//  Created by Ruslan Abbasov on 02.11.2022.
//

import UIKit

class TextFieldHalfTableViewCell: UITableViewCell {
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var borderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.lightGray.cgColor
        borderView.layer.cornerRadius = borderView.frame.size.height / 10
    }
    
}
