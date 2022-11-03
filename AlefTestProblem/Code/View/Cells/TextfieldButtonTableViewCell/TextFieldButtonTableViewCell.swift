//
//  TextFieldButtonTableViewCell.swift
//  AlefTestProblem
//
//  Created by Ruslan Abbasov on 31.10.2022.
//

import UIKit
import Combine

class TextFieldButtonTableViewCell: UITableViewCell {
    public let pressSubject = PassthroughSubject<Int?, Never>()
    var index: Int?
    public var isSubscribedFlag = false

    public var cancellable: AnyCancellable?

    @IBOutlet weak var textfieldNameLabel: UILabel!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var borderView: UIView!


    @IBAction func buttonPress(_ sender: Any) {
        self.pressSubject.send(index)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.lightGray.cgColor
        borderView.layer.cornerRadius = borderView.frame.size.height / 10
    }

}
