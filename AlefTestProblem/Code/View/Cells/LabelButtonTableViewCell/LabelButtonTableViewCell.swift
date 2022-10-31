//
//  LabelButtonTableViewCell.swift
//  AlefTestProblem
//
//  Created by Ruslan Abbasov on 31.10.2022.
//

import UIKit

class LabelButtonTableViewCell: UITableViewCell {
    @IBOutlet weak var addButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        addButton.layer.borderColor = UIColor.systemBlue.cgColor

        addButton.layer.borderWidth  = 2.0
        addButton.layer.cornerRadius =  addButton.frame.size.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
