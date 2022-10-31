//
//  TextFieldTableViewCell.swift
//  AlefTestProblem
//
//  Created by Ruslan Abbasov on 26.10.2022.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.lightGray.cgColor
        borderView.layer.cornerRadius = borderView.frame.size.height / 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
