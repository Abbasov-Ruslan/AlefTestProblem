//
//  TextFieldButtonTableViewCell.swift
//  AlefTestProblem
//
//  Created by Ruslan Abbasov on 31.10.2022.
//

import UIKit
import Combine

class TextFieldButtonTableViewCell: UITableViewCell {
    public let pressSubject = PassthroughSubject<UUID?, Never>()
    public var isSubscribedFlag = false
    public var cancellable: AnyCancellable?

    private var id: UUID?

    @IBOutlet private weak var textfieldNameLabel: UILabel!
    @IBOutlet private weak var textfield: UITextField!
    @IBOutlet private weak var borderView: UIView!


    @IBAction func buttonPress(_ sender: Any) {
        self.pressSubject.send(id)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.lightGray.cgColor
        borderView.layer.cornerRadius = borderView.frame.size.height / 10
    }

    public func clearTextField() {
        textfield.text = ""
    }

    public func changeTextfieldNameLabel(text: String) {
        textfieldNameLabel.text = text
    }

    public func setID(id: UUID) {
        self.id = id
    }

    public func getIDNumber() -> UUID {
        guard let id = self.id else {
            print("error: ID is Nil")
            return UUID()
        }
        return id
    }

}
