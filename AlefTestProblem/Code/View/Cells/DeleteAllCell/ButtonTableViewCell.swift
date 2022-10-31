//
//  DeleteAllCell.swift
//  AlefTestProblem
//
//  Created by Ruslan Abbasov on 31.10.2022.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {
    @IBOutlet weak var deleteAllButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        deleteAllButton.layer.borderColor = UIColor.systemRed.cgColor

        deleteAllButton.layer.borderWidth  = 2.0
        deleteAllButton.layer.cornerRadius =  deleteAllButton.frame.size.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
