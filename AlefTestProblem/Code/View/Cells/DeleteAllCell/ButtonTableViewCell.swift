//
//  DeleteAllCell.swift
//  AlefTestProblem
//
//  Created by Ruslan Abbasov on 31.10.2022.
//

import UIKit
import Combine

class ButtonTableViewCell: UITableViewCell {

    public let tapSubject = PassthroughSubject<Void, Never>()
  
    @IBOutlet private weak var deleteAllButton: UIButton!

    @IBAction private func buttonTap(_ sender: Any) {
        tapAction()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        deleteAllButton.layer.borderColor = UIColor.systemRed.cgColor

        deleteAllButton.layer.borderWidth  = 2.0
        deleteAllButton.layer.cornerRadius =  deleteAllButton.frame.size.height / 2


    }

    func tapAction() {
        tapSubject.send()
    }
    
}
